import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../l10n/app_localizations.dart';

class WordDefenseWidget extends StatefulWidget {
  final VoidCallback onQuit;

  const WordDefenseWidget({super.key, required this.onQuit});

  @override
  State<WordDefenseWidget> createState() => _WordDefenseWidgetState();
}

class DefenseEnemy {
  final String id;
  final String text; // The target word
  final String translation; // Hint
  double x; // 0.0 to 1.0 (Horizontal)
  double y; // 0.0 to 1.0 (Vertical, 0=Top, 1=Bottom/Base)
  final double speed;
  final Color color;
  bool isTargeted;

  DefenseEnemy({
    required this.id,
    required this.text,
    required this.translation,
    required this.x,
    required this.y,
    required this.speed,
    required this.color,
    this.isTargeted = false,
  });
}

class _WordDefenseWidgetState extends State<WordDefenseWidget> with TickerProviderStateMixin {
  // Game Config
  static const int _fps = 60;
  static const double _baseSpawnRate = 2.5; 

  // State
  bool _isPlaying = false;
  bool _isGameOver = false;
  int _score = 0;
  int _lives = 5;
  int _wave = 1;
  
  final List<DefenseEnemy> _enemies = [];
  DefenseEnemy? _currentTarget; // The enemy currently being attacked
  
  Timer? _gameLoopTimer;
  double _timeSinceSpawn = 0;
  int _spawnsRemaining = 0;

  @override
  void initState() {
    super.initState();
    // Auto-start game after small delay
    Future.delayed(const Duration(milliseconds: 500), _startGame);
  }

  @override
  void dispose() {
    _stopGame();
    super.dispose();
  }

  void _startGame() {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.filteredMaterialRecords.isEmpty) {
      // Show error? For now just quit to lobby
      widget.onQuit();
      return;
    }

    setState(() {
      _isPlaying = true;
      _isGameOver = false;
      _score = 0;
      _lives = 5;
      _wave = 1;
      _enemies.clear();
      _currentTarget = null;
      _timeSinceSpawn = 0;
      _spawnsRemaining = 10; // 10 enemies per wave?
    });

    _startListening(appState);

    _gameLoopTimer?.cancel();
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 1000 ~/ _fps), (timer) {
      _updateGame(appState);
    });
  }

  void _stopGame() {
    _gameLoopTimer?.cancel();
    final appState = Provider.of<AppState>(context, listen: false);
    appState.stopMode4Listening();
  }

  void _startListening(AppState appState) {
    // Start continuous, but we logic-gate the checks
    appState.startMode4Listening(
      lang: appState.targetLang, // Always speak target? Or Configurable? Assuming Target for practice.
      onResult: (text, isFinal) {
        if (_currentTarget != null) {
          _checkAttack(text);
        }
      },
    );
  }

  void _checkAttack(String spokenText) {
    if (_currentTarget == null) return;
    
    final targetText = _normalize(_currentTarget!.text);
    final spoken = _normalize(spokenText);

    bool match = false;
    if (targetText == spoken || spoken.contains(targetText)) {
      match = true;
    }

    if (match) {
      // Enemy Defeated
      setState(() {
        _score += 100;
        _enemies.remove(_currentTarget);
        _currentTarget = null;
        
        // Wave Progress
        if (_enemies.isEmpty && _spawnsRemaining <= 0) {
          // Wave Complete - Increase difficulty
          _wave++;
          _lives++; // Bonus life
          _spawnsRemaining = 10 + (_wave * 2);
        }
      });
    }
  }

  String _normalize(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^\w\s가-힣0-9]'), '').trim();
  }

  void _updateGame(AppState appState) {
    if (!_isPlaying || _isGameOver) return;

    final dt = 1.0 / _fps;
    
    // Spawning
    _timeSinceSpawn += dt;
    if (_spawnsRemaining > 0 && _timeSinceSpawn > (_baseSpawnRate / sqrt(_wave))) {
      _spawnEnemy(appState);
      _timeSinceSpawn = 0;
      _spawnsRemaining--;
    }

    setState(() {
      for (var enemy in List<DefenseEnemy>.from(_enemies)) {
         // If targeted, pause movement! (Turn-based mechanic)
         if (enemy.isTargeted) continue;

         enemy.y += (enemy.speed * dt); // Move down
         
         if (enemy.y >= 1.0) {
           // Reached base
           _lives--;
           _enemies.remove(enemy);
           if (_lives <= 0) {
             _endGame();
           }
         }
      }
    });
  }

  void _spawnEnemy(AppState appState) {
    final records = appState.filteredMaterialRecords;
    final randomRecord = records[Random().nextInt(records.length)];
    
    // Determine Text (Source or Target?)
    // Usually Practice is Speak Target.
    // Display could be Source (Translate this!) or Target (Read this!).
    // Let's stick to "Read This" for pronunciation practice first.
    // Or configurable. Let's assume Read Target.
    final text = randomRecord['target_text'] as String;
    final meaning = randomRecord['source_text'] as String;

    _enemies.add(DefenseEnemy(
      id: UniqueKey().toString(),
      text: text,
      translation: meaning,
      x: 0.1 + Random().nextDouble() * 0.8, // Random X
      y: 0.0,
      speed: 0.05 + (_wave * 0.01), // Slow speed
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
    ));
  }

  void _endGame() {
    _stopGame();
    setState(() {
      _isGameOver = true;
      _isPlaying = false;
    });
  }

  void _targetEnemy(DefenseEnemy enemy) {
    setState(() {
      // Untarget previous
      if (_currentTarget != null) {
        _currentTarget!.isTargeted = false;
      }
      
      _currentTarget = enemy;
      enemy.isTargeted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isGameOver) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sentiment_very_dissatisfied, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(l10n.gameOver, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text("Score: $_score", style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _startGame, child: Text(l10n.playAgain)),
            TextButton(onPressed: widget.onQuit, child: Text(l10n.cancel)),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Game Field
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
               // Deselect if tapping background?
               if (_currentTarget != null) {
                 setState(() {
                   _currentTarget!.isTargeted = false;
                   _currentTarget = null;
                 });
               }
            },
            child: Container(
              color: Colors.green[50], // Grass?
              child: CustomPaint(
                painter: GridPainter(), // Optional grid
              ),
            ),
          ),
        ),
        
        // Base Line
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 20,
          child: Container(color: Colors.red.withValues(alpha: 0.3)),
        ),

        // Enemies
        ..._enemies.map((enemy) => Positioned(
          left: MediaQuery.of(context).size.width * enemy.x - 24, // Centered
          top: MediaQuery.of(context).size.height * enemy.y, // Y is 0.0 to 1.0 of Screen Height? careful with SafeAreas
          // Let's use relative sizing logic, but for now strict pixels from top 
          // might be weird if we don't know height.
          // Better to use Alignment in Stack? No, dynamic.
          // Let's assume height is roughly build context height.
          // We utilize LayoutBuilder optimally, but here shortcutting with MediaQuery.
          child: GestureDetector(
            onTap: () => _targetEnemy(enemy),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: enemy.isTargeted ? 60 : 48,
              height: enemy.isTargeted ? 60 : 48,
              decoration: BoxDecoration(
                 color: enemy.color,
                 shape: BoxShape.circle,
                 border: enemy.isTargeted ? Border.all(color: Colors.red, width: 3) : null,
                 boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
              ),
              child: Center(
                child: enemy.isTargeted 
                    ? const Icon(Icons.mic, color: Colors.white) 
                    : const Icon(Icons.android, color: Colors.white),
              ),
            ),
          ),
        )),

        // Battle Box (Target Display)
        if (_currentTarget != null)
          Positioned(
             bottom: 120, 
             left: 20, 
             right: 20, 
             child: Card(
               elevation: 8,
               color: Colors.white,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   children: [
                     Text(
                       _currentTarget!.text,
                       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
                       textAlign: TextAlign.center,
                     ),
                     const SizedBox(height: 8),
                     Text(
                       _currentTarget!.translation,
                       style: const TextStyle(fontSize: 16, color: Colors.grey),
                       textAlign: TextAlign.center,
                     ),
                     const SizedBox(height: 16),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(Icons.mic_none, color: Colors.red),
                         const SizedBox(width: 8),
                         Text(l10n.speakNow, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                       ],
                     )
                   ],
                 ),
               ),
             ),
          ),

        // HUD
        Positioned(
          top: 0, 
          left: 0, 
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                     children: [
                       const Icon(Icons.favorite, color: Colors.red),
                       Text(" $_lives", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     ],
                   ),
                   Row(
                     children: [
                       Text("Wave $_wave", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                     ],
                   ),
                   Text("Score: $_score", style: const TextStyle(fontSize: 20)),
                   IconButton(icon: const Icon(Icons.close), onPressed: widget.onQuit),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simple grid logic if needed
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
