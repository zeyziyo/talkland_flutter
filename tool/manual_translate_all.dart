import 'dart:convert';
import 'dart:io';

void main() {
  final translations = {
    // Existing Top 10
    'ja': {'basicWordRepository': '基本単語リポジトリ', 'basicSentenceRepository': '基本文リポジトリ'},
    'zh': {'basicWordRepository': '基础词汇库', 'basicSentenceRepository': '基础句库'},
    'zh_CN': {'basicWordRepository': '基础词汇库', 'basicSentenceRepository': '基础句库'},
    'zh_TW': {'basicWordRepository': '基礎詞彙庫', 'basicSentenceRepository': '基礎句庫'},
    'es': {'basicWordRepository': 'Repositorio de palabras básicas', 'basicSentenceRepository': 'Repositorio de oraciones básicas'},
    'fr': {'basicWordRepository': 'Référentiel de mots de base', 'basicSentenceRepository': 'Référentiel de phrases de base'},
    'de': {'basicWordRepository': 'Grundwortschatz', 'basicSentenceRepository': 'Grundsatz-Repository'},
    'ru': {'basicWordRepository': 'Базовый репозиторий слов', 'basicSentenceRepository': 'Базовый репозиторий предложений'},
    'it': {'basicWordRepository': 'Repository di parole di base', 'basicSentenceRepository': 'Repository di frasi di base'},
    'pt': {'basicWordRepository': 'Repositório de palavras básicas', 'basicSentenceRepository': 'Repositório de frases básicas'},
    
    // Remaining Languages
    'af': {'basicWordRepository': 'Basiese Woordbewaarplek', 'basicSentenceRepository': 'Basiese Sinbewaarplek'},
    'ar': {'basicWordRepository': 'مستودع الكلمات الأساسية', 'basicSentenceRepository': 'مستودع الجمل الأساسية'},
    'bn': {'basicWordRepository': 'মৌলিক শব্দ ভান্ডার', 'basicSentenceRepository': 'মৌলিক বাক্য ভান্ডার'},
    'cs': {'basicWordRepository': 'Základní úložiště slov', 'basicSentenceRepository': 'Základní úložiště vět'},
    'da': {'basicWordRepository': 'Grundlæggende ordarkiv', 'basicSentenceRepository': 'Grundlæggende sætningsarkiv'},
    'el': {'basicWordRepository': 'Βασικό Αποθετήριο Λέξεων', 'basicSentenceRepository': 'Βασικό Αποθετήριο Φράσεων'},
    'fa': {'basicWordRepository': 'مخزن کلمات پایه', 'basicSentenceRepository': 'مخزن جملات پایه'},
    'fi': {'basicWordRepository': 'Perussanavarasto', 'basicSentenceRepository': 'Peruslausevarasto'},
    'fil': {'basicWordRepository': 'Repository ng Mga Pangunahing Salita', 'basicSentenceRepository': 'Repository ng Mga Pangunahing Pangungusap'},
    'gu': {'basicWordRepository': 'મૂળભૂત શબ્દ ભંડાર', 'basicSentenceRepository': 'મૂળભૂત વાક્ય ભંડાર'},
    'he': {'basicWordRepository': 'מאגר מילים בסיסי', 'basicSentenceRepository': 'מאגר משפטים בסיסי'},
    'hi': {'basicWordRepository': 'बुनियादी शब्द भंडार', 'basicSentenceRepository': 'बुनियादी वाक्य भंडार'},
    'hu': {'basicWordRepository': 'Alapvető Szótár', 'basicSentenceRepository': 'Alapvető Mondattár'},
    'id': {'basicWordRepository': 'Repositori Kata Dasar', 'basicSentenceRepository': 'Repositori Kalimat Dasar'},
    'kn': {'basicWordRepository': 'ಮೂಲ ಪದ ಭಂಡಾರ', 'basicSentenceRepository': 'ಮೂಲ ವಾಕ್ಯ ಭಂಡಾರ'},
    'ml': {'basicWordRepository': 'അടിസ്ഥാന വാക്കുകളുടെ ശേഖരം', 'basicSentenceRepository': 'അടിസ്ഥാന വാചകങ്ങളുടെ ശേഖരം'},
    'mr': {'basicWordRepository': 'मूळ शब्द भांडार', 'basicSentenceRepository': 'मूळ वाक्य भांडार'},
    'ms': {'basicWordRepository': 'Repositori Kata Dasar', 'basicSentenceRepository': 'Repositori Ayat Dasar'},
    'nl': {'basicWordRepository': 'Basis Woordenlijst', 'basicSentenceRepository': 'Basis Zinnenlijst'},
    'no': {'basicWordRepository': 'Grunnleggende ordlager', 'basicSentenceRepository': 'Grunnleggende setningslager'},
    'pa': {'basicWordRepository': 'ਮੁਢਲੇ ਸ਼ਬਦ ਭੰਡਾਰ', 'basicSentenceRepository': 'ਮੁਢਲੇ ਵਾਕ ਭੰਡਾਰ'},
    'pl': {'basicWordRepository': 'Podstawowy magazyn słów', 'basicSentenceRepository': 'Podstawowy magazyn zdań'},
    'ro': {'basicWordRepository': 'Depozit de cuvinte de bază', 'basicSentenceRepository': 'Depozit de propoziții de bază'},
    'sv': {'basicWordRepository': 'Grundläggande ordlista', 'basicSentenceRepository': 'Grundläggande meningslista'},
    'sw': {'basicWordRepository': 'Hifadhi ya Maneno ya Msingi', 'basicSentenceRepository': 'Hifadhi ya Sentensi za Msingi'},
    'ta': {'basicWordRepository': 'அடிப்படை சொல் களஞ்சியம்', 'basicSentenceRepository': 'அடிப்படை வாக்கிய களஞ்சியம்'},
    'te': {'basicWordRepository': 'ప్రాథమిక పద రిపోజిటరీ', 'basicSentenceRepository': 'ప్రాథమిక వాక్య రిపోజిటరీ'},
    'th': {'basicWordRepository': 'คลังคำศัพท์พื้นฐาน', 'basicSentenceRepository': 'คลังประโยคพื้นฐาน'},
    'tr': {'basicWordRepository': 'Temel Kelime Deposu', 'basicSentenceRepository': 'Temel Cümle Deposu'},
    'uk': {'basicWordRepository': 'Базовий репозиторій слів', 'basicSentenceRepository': 'Базовий репозиторій речень'},
    'ur': {'basicWordRepository': 'بنیادی الفاظ کا ذخیرہ', 'basicSentenceRepository': 'بنیادی جملوں کا ذخیرہ'},
    'vi': {'basicWordRepository': 'Kho từ cơ bản', 'basicSentenceRepository': 'Kho câu cơ bản'},
  };

  final dir = Directory('lib/l10n');
  if (!dir.existsSync()) return;

  for (final file in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'))) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final langCode = fileName.replaceAll('app_', '').replaceAll('.arb', '');
    
    if (translations.containsKey(langCode)) {
      try {
        final content = file.readAsStringSync();
        final map = jsonDecode(content) as Map<String, dynamic>;
        
        map['basicWordRepository'] = translations[langCode]!['basicWordRepository'];
        map['basicSentenceRepository'] = translations[langCode]!['basicSentenceRepository'];
        
        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(map));
        print('✅ Updated $langCode');
      } catch (e) {
        print('❌ Error updating $langCode: $e');
      }
    }
  }
}
