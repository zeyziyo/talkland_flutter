import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'talkie.db';
  static const int _dbVersion = 16; // Phase 105: Adding indexes for performance

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<void> reset() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await createBaseTables(db);
        await ensureDefaultMaterial(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ... (Existing upgrades from v2 to v14)
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE dialogue_groups (
              id TEXT PRIMARY KEY,
              user_id TEXT,
              title TEXT,
              persona TEXT,
              created_at TEXT NOT NULL
            )
          ''');
          await db.execute('ALTER TABLE translations ADD COLUMN dialogue_id TEXT');
          await db.execute('ALTER TABLE translations ADD COLUMN speaker TEXT');
          await db.execute('ALTER TABLE translations ADD COLUMN sequence_order INTEGER');
          print('[DB] Upgraded to version 2');
        }

        // Phase 99: v15
        if (oldVersion < 15) {
          print('[DB] Migrating to version 15: Normalizing local tables');
          await _migrateToV15(db);
        }

        // Phase 105: v16
        if (oldVersion < 16) {
          print('[DB] Migrating to version 16: Adding indexes for performance');
          await _addIndexesV16(db);
        }
      },
    );
  }

  static Future<void> _addIndexesV16(Database db) async {
    await db.transaction((txn) async {
      // 1. Tag Search Optimization
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_item_tags_tag ON item_tags (tag)');
      
      // 2. Text Search Optimization (for Autocomplete/LIKE queries)
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_words_text ON words (text)');
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_sentences_text ON sentences (text)');
      
      // 3. User Filter Optimization
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_sentences_style ON sentences (style)');
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_words_pos ON words (pos)');
    });
  }

  static Future<void> _migrateToV15(Database db) async {
    // SQLite doesn't support DROP COLUMN easily. Use Rename-Copy-Drop pattern.
    await db.transaction((txn) async {
      // 1. Normalize 'words' table (Remove 'style')
      await txn.execute('ALTER TABLE words RENAME TO words_old');
      await txn.execute('''
        CREATE TABLE words (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_id INTEGER,
          text TEXT NOT NULL,
          lang_code TEXT NOT NULL,
          root TEXT,
          pos TEXT,
          form_type TEXT,
          note TEXT,
          created_at TEXT NOT NULL,
          is_memorized INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0,
          audio_file BLOB,
          last_reviewed TEXT,
          review_count INTEGER DEFAULT 0
        )
      ''');
      await txn.execute('''
        INSERT INTO words (id, group_id, text, lang_code, root, pos, form_type, note, created_at, is_memorized, is_synced, audio_file, last_reviewed, review_count)
        SELECT id, group_id, text, lang_code, root, pos, form_type, note, created_at, is_memorized, is_synced, audio_file, last_reviewed, review_count FROM words_old
      ''');
      await txn.execute('DROP TABLE words_old');

      // 2. Normalize 'sentences' table (Remove 'form_type', 'root')
      await txn.execute('ALTER TABLE sentences RENAME TO sentences_old');
      await txn.execute('''
        CREATE TABLE sentences (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_id INTEGER,
          text TEXT NOT NULL,
          lang_code TEXT NOT NULL,
          pos TEXT,
          style TEXT,
          note TEXT,
          created_at TEXT NOT NULL,
          is_memorized INTEGER DEFAULT 0,
          is_synced INTEGER DEFAULT 0,
          audio_file BLOB,
          last_reviewed TEXT,
          review_count INTEGER DEFAULT 0
        )
      ''');
      await txn.execute('''
        INSERT INTO sentences (id, group_id, text, lang_code, pos, style, note, created_at, is_memorized, is_synced, audio_file, last_reviewed, review_count)
        SELECT id, group_id, text, lang_code, pos, style, note, created_at, is_memorized, is_synced, audio_file, last_reviewed, review_count FROM sentences_old
      ''');
      await txn.execute('DROP TABLE sentences_old');
      
      // Re-create indexes
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_words_group_id ON words (group_id)');
      await txn.execute('CREATE INDEX IF NOT EXISTS idx_sentences_group_id ON sentences (group_id)');
    });
  }

  static Future<void> createBaseTables(Database db) async {
    // Content from DatabaseService._createBaseTables
    await db.execute('''
      CREATE TABLE IF NOT EXISTS words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        text TEXT NOT NULL,
        lang_code TEXT NOT NULL,
        root TEXT,
        pos TEXT,
        form_type TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        is_memorized INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0,
        audio_file BLOB,
        last_reviewed TEXT,
        review_count INTEGER DEFAULT 0
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sentences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER,
        text TEXT NOT NULL,
        lang_code TEXT NOT NULL,
        pos TEXT,
        style TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        is_memorized INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0,
        audio_file BLOB,
        last_reviewed TEXT,
        review_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS item_tags (
        item_id INTEGER NOT NULL,
        item_type TEXT NOT NULL,
        tag TEXT NOT NULL,
        PRIMARY KEY (item_id, item_type, tag)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS study_materials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        source TEXT,
        source_language TEXT,
        target_language TEXT,
        file_name TEXT,
        created_at TEXT NOT NULL,
        imported_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dialogue_groups (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT,
        persona TEXT,
        location TEXT,
        note TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dialogue_id TEXT NOT NULL,
        group_id INTEGER NOT NULL,
        speaker TEXT,
        participant_id TEXT,
        sequence_order INTEGER NOT NULL,
        created_at TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now')),
        FOREIGN KEY (dialogue_id) REFERENCES dialogue_groups (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS dialogue_participants (
        id TEXT PRIMARY KEY,
        dialogue_id TEXT NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL, 
        gender TEXT,
        lang_code TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Phase 105: Performance Indexes
    await db.execute('CREATE INDEX IF NOT EXISTS idx_words_group_id ON words (group_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sentences_group_id ON sentences (group_id)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_item_tags_tag ON item_tags (tag)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_words_text ON words (text)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sentences_text ON sentences (text)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sentences_style ON sentences (style)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_words_pos ON words (pos)');
  }

  static Future<void> ensureDefaultMaterial(Database db) async {
    final result = await db.query('study_materials', where: 'id = 0');
    if (result.isEmpty) {
      await db.insert('study_materials', {
        'id': 0,
        'subject': 'Basic',
        'source': 'System',
        'source_language': 'auto',
        'target_language': 'auto',
        'created_at': DateTime.now().toIso8601String(),
        'imported_at': DateTime.now().toIso8601String(),
      });
    }
  }
}
