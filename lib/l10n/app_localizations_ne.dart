// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get helpTitle => 'मद्दत र गाइड';

  @override
  String get helpTabModes => 'मोड विवरण';

  @override
  String get helpTabJson => 'JSON ढाँचा';

  @override
  String get helpTabTour => 'अनुभव लिनुहोस्';

  @override
  String get helpMode1Desc =>
      'आवाज पहिचान गरेर अनुवाद गर्नुहोस्, र परिणाम सुन्न सक्नुहुन्छ।';

  @override
  String get helpMode1Details =>
      '• भाषा सेटिङ: माथि/तलको आइकन थिचेर भाषा परिवर्तन गर्नुहोस्\n• शब्द/वाक्य टगल: मोड परिवर्तन\n• आवाज इनपुट: माइक्रोफोन आइकन थिचेर सुन्न सुरु/बन्द गर्नुहोस्\n• पाठ इनपुट: सिधै टाइप गरेर अनुवाद गर्नुहोस्\n• स्वतः खोजी: समान अवस्थित वाक्य पत्ता लगाउनुहोस्\n• अनुवाद: अनुवाद बटन थिचेर तुरुन्तै अनुवाद गर्नुहोस्\n• सुन्नुहोस्: स्पिकर आइकनबाट TTS प्ले गर्नुहोस्\n• सुरक्षित गर्नुहोस्: \'डाटा सुरक्षित गर्नुहोस्\' मा रेकर्ड थप्नुहोस्\n• मेटाउनुहोस्: इनपुट रिसेट गर्नुहोस्';

  @override
  String get helpMode2Desc =>
      'सुरक्षित गरिएका वाक्यहरूको समीक्षा गर्नुहोस्, र स्वतः लुकाउने सुविधाको साथ कण्ठ भएको छ कि छैन जाँच गर्नुहोस्।';

  @override
  String get helpMode2Details =>
      '• सामग्री छनोट गर्नुहोस्: विशेष सामग्री संग्रह वा \'सबै समीक्षा\' छनोट गर्नुहोस्\n• कार्ड फ्लिप गर्नुहोस्: \'देखाउनुहोस्/लुकाउनुहोस्\' बाट अनुवाद जाँच गर्नुहोस् (स्वतः सिकाइ जाँच)\n• सुन्नुहोस्: वाक्य TTS प्ले गर्नुहोस्\n• सिकाइ पूरा भयो: चेक मार्क (V) बाट सिकाइ पूरा भएको रूपमा प्रशोधन गर्नुहोस्\n• मेटाउनुहोस्: कार्डलाई लामो समयसम्म थिचेर रेकर्ड मेटाउनुहोस्\n• खोजी सर्तहरू: ट्याग, हालसालैका वस्तुहरू, सुरु हुने अक्षरबाट फिल्टर गर्नुहोस्';

  @override
  String get helpMode3Desc =>
      'वाक्य सुनेर पछ्याउँदै (छायांकन) उच्चारण अभ्यास गर्नुहोस्।';

  @override
  String get helpMode3Details =>
      '• सामग्री छनोट गर्नुहोस्: सिक्नको लागि सामग्री संग्रह छनोट गर्नुहोस्\n• अन्तराल सेटिङ: [-] [+] बटनबाट वाक्यको बीचमा पर्खने समय समायोजन गर्नुहोस् (३ सेकेन्ड~६० सेकेन्ड)\n• सुरु/बन्द: Shadowing सत्र नियन्त्रण गर्नुहोस्\n• बोल्नुहोस्: आवाज सुनेर दोहोर्याउनुहोस्\n• प्रतिक्रिया: शुद्धता स्कोर (०-१००) र रङ प्रदर्शन गर्नुहोस्\n• खोजी सर्तहरू: ट्याग, हालसालैका वस्तुहरू, सुरु हुने अक्षरबाट अभ्यास गर्ने लक्ष्य फिल्टर गर्नुहोस्';

  @override
  String get helpModeChatDesc =>
      'एआई व्यक्तित्वसँग कुरा गरेर वास्तविक कुराकानी अभ्यास गर्नुहोस्।';

  @override
  String get helpModeChatDetails =>
      '• AI च्याट: आफ्नो भाषामा बोलेर कुराकानी अभ्यास गर्नुहोस्\n• बहु व्यक्तित्व: कुराकानीको बबलमाथिको मेनुबाट अर्को व्यक्तिको लिङ्ग/भाषा/नाम परिवर्तन गर्न सकिन्छ\n• साझेदार थप्नुहोस्: + बटनबाट नयाँ कुराकानी गर्ने व्यक्ति (Stranger) थप्नुहोस्\n• GPS: हालको स्थानमा आधारित नाटक\n• स्वतः सुरक्षित: कुराकानीको सामग्री स्वतः अनुवाद र सुरक्षित हुन्छ';

  @override
  String get helpJsonDesc =>
      'मोड ३ मा प्रयोग गर्नको लागि JSON फाइलबाट सिकाइ सामग्री आयात गर्न, निम्न ढाँचा पालना गर्नुहोस्:';

  @override
  String get helpDialogueImportDesc =>
      'JSON फाइलबाट सम्पूर्ण कुराकानी सेट आयात गर्नुहोस्।';

  @override
  String get helpDialogueImportDetails =>
      '• JSON संरचना: `entries` को सट्टा `dialogues` array प्रयोग गर्नुहोस्\n• स्वतः रिकभर: कुराकानीको शीर्षक, व्यक्तित्व, सन्देश क्रम रिकभर हुन्छ।\n• स्थान: आयात गरिएको कुराकानी AI च्याट मोडको \'रेकर्ड\' ट्याबमा देखा पर्छ।';

  @override
  String get helpTourDesc =>
      '**हाइलाइट गरिएको वृत्त**ले मुख्य सुविधाहरूको मार्गदर्शन गर्दछ।\n(उदाहरण: **हाइलाइट गरिएको वृत्त**ले देखाएको कार्डलाई लामो समयसम्म थिचेर मेटाउन सकिन्छ।)';

  @override
  String get partnerMode => 'साझेदार मोड';

  @override
  String get manual => 'म्यानुअल इनपुट';

  @override
  String get speaker => 'वक्ता';

  @override
  String get switchToAi => 'AI मोडमा परिवर्तन गर्नुहोस्';

  @override
  String get switchToPartner => 'साझेदार मोडमा परिवर्तन गर्नुहोस्';

  @override
  String get currentLocation => 'हालको स्थान';

  @override
  String get location => 'स्थान';

  @override
  String get partner => 'साझेदार';

  @override
  String get me => 'म';

  @override
  String get currentMaterialLabel => 'हालको चयन गरिएको सामग्री संग्रह:';

  @override
  String get basicMaterialRepository => 'आधारभूत वाक्य/शब्द भण्डार';

  @override
  String get word => 'शब्द';

  @override
  String get sentence => 'वाक्य';

  @override
  String get appTitle => 'Talkie';

  @override
  String tabReview(int count) {
    return 'समीक्षा ($count)';
  }

  @override
  String tabStudyMaterial(int count) {
    return 'अध्ययन सामग्री ($count)';
  }

  @override
  String get mode2Title => 'समीक्षा';

  @override
  String get search => 'खोज्नुहोस्';

  @override
  String get translate => 'अनुवाद गर्नुहोस्';

  @override
  String get listen => 'सुन्नुहोस्';

  @override
  String get saveData => 'डाटा सुरक्षित गर्नुहोस्';

  @override
  String get saved => 'सुरक्षित गरियो';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get materialInfo => 'सामग्री जानकारी';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get confirm => 'पक्का गर्नुहोस्';

  @override
  String get refresh => 'रिफ्रेस गर्नुहोस्';

  @override
  String studyRecords(int count) {
    return 'अध्ययन रेकर्ड ($count)';
  }

  @override
  String get targetLanguageFilter => 'लक्ष्य भाषा फिल्टर:';

  @override
  String get noRecords => 'चयन गरिएको भाषाको अध्ययन रेकर्ड छैन';

  @override
  String get saveTranslationsFromSearch =>
      'खोज मोडबाट अनुवाद सुरक्षित गर्ने प्रयास गर्नुहोस्';

  @override
  String get flip => 'देखाउनुहोस्';

  @override
  String get hide => 'लुकाउनुहोस्';

  @override
  String get deleteRecord => 'रेकर्ड मेटाउनुहोस्';

  @override
  String get confirmDelete => 'के तपाइँ यो अध्ययन रेकर्ड मेटाउन चाहनुहुन्छ?';

  @override
  String get recordDeleted => 'रेकर्ड मेटाइयो';

  @override
  String deleteFailed(String error) {
    return 'मेटाउन असफल भयो: $error';
  }

  @override
  String get importJsonFile => 'JSON फाइल आयात गर्नुहोस्';

  @override
  String get importing => 'आयात गरिँदै...';

  @override
  String get importComplete => 'आयात गरियो';

  @override
  String get importFailed => 'आयात गर्न असफल भयो';

  @override
  String importFile(String fileName) {
    return 'फाइल: $fileName';
  }

  @override
  String importTotal(int count) {
    return 'कुल: $count वटा';
  }

  @override
  String importAdded(int count) {
    return 'थपियो: $count वटा';
  }

  @override
  String importSkipped(int count) {
    return 'छोडियो: $count वटा';
  }

  @override
  String get errors => 'त्रुटिहरू:';

  @override
  String get error => 'त्रुटि';

  @override
  String importErrorMessage(String error) {
    return 'फाइल आयात गर्न असफल भयो:\\n$error';
  }

  @override
  String get selectStudyMaterial => 'अध्ययन सामग्री चयन गर्नुहोस्';

  @override
  String get subject => 'विषय:';

  @override
  String get source => 'स्रोत:';

  @override
  String get file => 'फाइल:';

  @override
  String progress(int current, int total) {
    return 'प्रगति: $current / $total';
  }

  @override
  String get importJsonFilePrompt => 'JSON फाइल आयात गर्नुहोस्';

  @override
  String get selectMaterialPrompt => 'अध्ययन सामग्री चयन गर्नुहोस्';

  @override
  String get studyComplete => 'अध्ययन पूरा भयो';

  @override
  String get markAsStudied => 'अध्ययनको रूपमा चिन्ह लगाउनुहोस्';

  @override
  String get listening => 'सुन्दै...';

  @override
  String get recognized => 'पहिचान भयो';

  @override
  String recognitionFailed(String error) {
    return 'आवाज पहिचान गर्न असफल भयो: $error';
  }

  @override
  String get checking => 'जाँच गर्दै...';

  @override
  String get translating => 'अनुवाद गरिँदै...';

  @override
  String get translationComplete => 'अनुवाद गरियो (सुरक्षित गर्न आवश्यक)';

  @override
  String get translationLoaded => 'सुरक्षित गरिएको अनुवाद लोड गरियो';

  @override
  String translationFailed(String error) {
    return 'अनुवाद गर्न असफल भयो: $error';
  }

  @override
  String get enterTextToTranslate => 'अनुवाद गर्न पाठ प्रविष्ट गर्नुहोस्';

  @override
  String get saving => 'सुरक्षित गर्दै...';

  @override
  String get noTranslationToSave => 'सुरक्षित गर्न कुनै अनुवाद छैन';

  @override
  String saveFailed(String error) {
    return 'सुरक्षित गर्न असफल भयो: $error';
  }

  @override
  String get playing => 'प्ले गर्दै...';

  @override
  String get noTextToPlay => 'प्ले गर्न कुनै पाठ छैन';

  @override
  String playbackFailed(String error) {
    return 'प्ले गर्न असफल भयो: $error';
  }

  @override
  String get sourceLanguage => 'मूल भाषा';

  @override
  String get targetLanguage => 'लक्ष्य भाषा';

  @override
  String get similarTextFound => 'समान पाठ भेटियो';

  @override
  String get useExistingText => 'अवस्थित पाठ प्रयोग गर्नुहोस्';

  @override
  String get createNew => 'नयाँ वाक्यको रूपमा जारी राख्नुहोस्';

  @override
  String reviewCount(int count) {
    return 'समीक्षा $count पटक';
  }

  @override
  String get tabSpeaking => 'बोल्दै';

  @override
  String get speakingPractice => 'बोल्ने अभ्यास';

  @override
  String intervalSeconds(int seconds) {
    return 'अन्तराल: $seconds सेकेन्ड';
  }

  @override
  String get yourPronunciation => 'मेरो उच्चारण';

  @override
  String get correctAnswer => 'सही उत्तर';

  @override
  String score(String score) {
    return 'शुद्धता: $score%';
  }

  @override
  String get perfect => 'उत्कृष्ट!';

  @override
  String get good => 'राम्रो छ';

  @override
  String get tryAgain => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get startPractice => 'अभ्यास सुरु गर्नुहोस्';

  @override
  String get stopPractice => 'अभ्यास रोक्नुहोस्';

  @override
  String get menuOnlineLibrary => 'Online Library';

  @override
  String get startTutorial => 'ट्यूटोरियल सुरु गर्नुहोस्';

  @override
  String get menuTutorial => 'Tutorial';

  @override
  String get tutorialMicTitle => 'आवाज इनपुट';

  @override
  String get tutorialMicDesc =>
      'माइक्रोफोन बटन थिचेर आवाजद्वारा इनपुट गर्न सक्नुहुन्छ।';

  @override
  String get tutorialTabDesc =>
      'यहाँबाट तपाईँले चाहेको अध्ययन मोड चयन गर्न सक्नुहुन्छ।';

  @override
  String get tutorialTapToContinue => 'जारी राख्न स्क्रिन ट्याप गर्नुहोस्';

  @override
  String get tutorialTransTitle => 'अनुवाद गर्नुहोस्';

  @override
  String get tutorialTransDesc => 'टाइप गरिएको पाठलाई अनुवाद गर्दछ।';

  @override
  String get tutorialSaveTitle => 'सुरक्षित गर्नुहोस्';

  @override
  String get tutorialSaveDesc =>
      'अनुवाद गरिएको परिणामलाई अध्ययन रेकर्डमा सुरक्षित गर्नुहोस्।';

  @override
  String get tutorialM2SelectTitle => 'सामग्री छनोट गर्नुहोस्';

  @override
  String get tutorialM2SelectDesc =>
      'माथिल्लो एप बारमा रहेको सामग्री सङ्ग्रह आइकन (📚) थिचेर अध्ययन गर्नको लागि सामग्री छनोट गर्नुहोस्।';

  @override
  String get tutorialM3SelectDesc =>
      'माथिल्लो एप बारमा रहेको सामग्री सङ्ग्रह आइकन (📚) थिचेर अभ्यास गर्नको लागि सामग्री छनोट गर्नुहोस्।';

  @override
  String get tutorialM2ListTitle => 'अध्ययन सूची';

  @override
  String get tutorialM2ListDesc =>
      'यो कार्डलाई लामो समयसम्म थिचेर (Long Click) मेटाउन सकिन्छ। सुरक्षित गरिएका वाक्यहरू जाँच गर्नुहोस् र फ्लिप गर्नुहोस्।';

  @override
  String get tutorialM3SelectTitle => 'सामग्री छनोट गर्नुहोस्';

  @override
  String get tutorialM3IntervalTitle => 'अन्तराल सेटिङ';

  @override
  String get tutorialM3IntervalDesc =>
      'वाक्यहरूको बीचमा पर्खने समय समायोजन गर्नुहोस्।';

  @override
  String get tutorialM3StartTitle => 'अभ्यास सुरु गर्नुहोस्';

  @override
  String get tutorialM3StartDesc =>
      'प्ले बटन थिचेर मातृभाषा वक्ताको आवाज सुन्नुहोस् र दोहोर्याउनुहोस्।';

  @override
  String get startWarning => 'चेतावनी';

  @override
  String get noVoiceDetected => 'आवाज पत्ता लागेन';

  @override
  String get tooltipSearch => 'खोज्नुहोस्';

  @override
  String get tooltipStudyReview => 'अध्ययन+समीक्षा';

  @override
  String get tooltipSpeaking => 'बोल्दै';

  @override
  String get tooltipDecrease => 'घटाउनुहोस्';

  @override
  String get tooltipIncrease => 'बढाउनुहोस्';

  @override
  String get languageSettings => 'भाषा सेटिङ';

  @override
  String get tutorialM2DropdownDesc =>
      'माथिल्लो मेनुबाट अध्ययन गर्नको लागि सामग्री छनोट गर्न सक्नुहुन्छ।';

  @override
  String get tutorialM2ImportDesc =>
      'तपाईँको उपकरणको फोल्डरबाट JSON फाइल आयात गर्नुहोस्।';

  @override
  String get tutorialLangSettingsTitle => 'भाषा सेटिङ';

  @override
  String get tutorialLangSettingsDesc =>
      'अनुवाद गर्नको लागि मूल भाषा र लक्ष्य भाषा सेट गर्नुहोस्।';

  @override
  String get copy => 'प्रतिलिपि गर्नुहोस्';

  @override
  String get copiedToClipboard => 'क्लिपबोर्डमा प्रतिलिपि गरियो!';

  @override
  String get tutorialContextTitle => 'स्थिति/सन्दर्भ ट्याग';

  @override
  String get tutorialContextDesc =>
      'एउटै वाक्य भए पनि स्थिति (उदाहरण: बिहान, बेलुका) लेखेर छुट्टै सुरक्षित गर्न सकिन्छ।';

  @override
  String get thinkingTimeInterval => 'सोच्ने समय अन्तराल';

  @override
  String get thinkingTimeDesc => 'सही उत्तर सार्वजनिक हुनु अघि सोच्ने समय हो।';

  @override
  String get autoPlay => 'स्वतः प्ले';

  @override
  String get timeUp => 'समय सकियो!';

  @override
  String get gameModeTitle => 'खेल मोड';

  @override
  String get gameModeDesc => 'अभ्यास गर्न खेल मोड चयन गर्नुहोस्';

  @override
  String get wordDefenseTitle => 'शब्द डिफेन्स';

  @override
  String get wordDefenseDesc =>
      'शत्रु आइपुग्नु अघि शब्द बोलेर आधारको रक्षा गर्नुहोस्।';

  @override
  String get dialogueQuestTitle => 'कुराकानी खोज';

  @override
  String get dialogueQuestDesc =>
      'नाटकको माध्यमबाट कुराकानी अभ्यास गर्नुहोस्। उपयुक्त जवाफ छान्नुहोस् र बोल्नुहोस्।';

  @override
  String get labelType => 'प्रकार:';

  @override
  String get labelWord => 'शब्द';

  @override
  String get labelSentence => 'वाक्य';

  @override
  String get contextTagLabel =>
      'सन्दर्भ/स्थिति (वैकल्पिक) - उदाहरण: बिहानको अभिवादन, आदरार्थी';

  @override
  String get contextTagHint => 'पछि छुट्याउन सजिलो होस् भनेर स्थिति लेख्नुहोस्';

  @override
  String get usageLimitTitle => 'सीमा पुग्यो';

  @override
  String get translationLimitExceeded => 'अनुवाद सीमा नाघ्यो';

  @override
  String get translationLimitMessage =>
      'दैनिक निःशुल्क अनुवाद (5 पटक) सबै प्रयोग गरिसक्नुभयो।\\n\\nविज्ञापन हेरेर तुरुन्तै ५ पटक भर्न चाहनुहुन्छ?';

  @override
  String get watchAdAndRefill => 'विज्ञापन हेरेर भर्नुहोस् (+5 पटक)';

  @override
  String get translationRefilled => 'अनुवादको सङ्ख्या ५ पटक भरिएको छ!';

  @override
  String get adLoading =>
      'विज्ञापन लोड हुँदैछ। कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get reviewAll => 'सबै समीक्षा';

  @override
  String totalRecords(int count) {
    return 'जम्मा $count वटा रेकर्ड (सबै हेर्नुहोस्)';
  }

  @override
  String get filterAll => 'सबै';

  @override
  String get practiceWordsOnly => 'शब्दहरू मात्र अभ्यास गर्नुहोस्';

  @override
  String get resetPracticeHistory => 'अभ्यास इतिहास रिसेट गर्नुहोस्';

  @override
  String get retry => 'फेरि प्रयास गर्ने?';

  @override
  String get noStudyMaterial => 'अध्ययन सामग्री छैन।';

  @override
  String get gameOver => 'Game Over';

  @override
  String get playAgain => 'फेरि खेल्नुहोस्';

  @override
  String get speakNow => 'अब बोल्नुहोस्!';

  @override
  String get scoreLabel => 'अंक';

  @override
  String get viewOnlineGuide => 'अनलाइन गाइड हेर्नुहोस्';

  @override
  String get getMaterials => 'सामग्री प्राप्त गर्नुहोस्';

  @override
  String get swapLanguages => 'भाषाहरू बदल्नुहोस्';

  @override
  String get next => 'अर्को';

  @override
  String get wordModeLabel => 'शब्द मोड';

  @override
  String get accuracy => 'शुद्धता';

  @override
  String get basicDefault => 'आधारभूत';

  @override
  String get basic => 'आधारभूत';

  @override
  String get tutorialM3WordsTitle => 'शब्द अभ्यास';

  @override
  String get tutorialM3WordsDesc =>
      'चेक गरेमा सुरक्षित गरिएका शब्दहरू मात्र अभ्यास हुन्छ।';

  @override
  String get enterTextHint => 'अनुवाद गर्न पाठ प्रविष्ट गर्नुहोस्';

  @override
  String get micButtonTooltip => 'आवाज पहिचान सुरु गर्नुहोस्';

  @override
  String get menuHelp => 'मद्दत';

  @override
  String get menuWebDownload => 'होमपेज';

  @override
  String get menuDeviceImport => 'उपकरणबाट सामग्री आयात गर्नुहोस्';

  @override
  String get menuSettings => 'भाषा सेटिङ';

  @override
  String get basicWords => 'आधारभूत शब्द भण्डार';

  @override
  String get basicSentences => 'आधारभूत वाक्य भण्डार';

  @override
  String get selectMaterialSet => 'अध्ययन सामग्री सङ्ग्रह छनोट गर्नुहोस्';

  @override
  String get sectionWords => 'शब्दहरू';

  @override
  String get sectionSentences => 'वाक्यहरू';

  @override
  String get languageSettingsTitle => 'भाषा सेटिङ';

  @override
  String get sourceLanguageLabel => 'मेरो भाषा (Source)';

  @override
  String get targetLanguageLabel => 'सिक्ने भाषा (Target)';

  @override
  String get mode3Start => 'सुरु';

  @override
  String get mode3Stop => 'बन्द';

  @override
  String get mode3Next => 'अर्को';

  @override
  String get mode3TryAgain => 'पुनः प्रयास गर्नुहोस्';

  @override
  String get tutorialM3ResetTitle => 'रेकर्ड रिसेट गर्नुहोस्';

  @override
  String get tutorialSwapDesc =>
      'मेरो भाषा र सिक्ने भाषालाई एकअर्कासँग बदल्नुहोस्।';

  @override
  String get recognizedText => 'पहिचान गरिएको उच्चारण:';

  @override
  String titleFormat(Object materialName, Object type) {
    return '$type: $materialName';
  }

  @override
  String get tutorialM3ResetDesc =>
      'प्रगति र शुद्धता अंक रिसेट गरेर सुरुदेखि नै सुरु गर्नुहोस्।';

  @override
  String get menuSelectMaterialSet => 'अध्ययन सामग्री सङ्ग्रह छनोट गर्नुहोस्';

  @override
  String get sectionWord => 'शब्द खण्ड';

  @override
  String get sectionSentence => 'वाक्य खण्ड';

  @override
  String get tabWord => 'शब्द';

  @override
  String get tabSentence => 'वाक्य';

  @override
  String get errorProfanity =>
      'यसमा अश्लील शब्दहरू समावेश भएकोले अनुवाद गर्न सकिँदैन।';

  @override
  String get errorHateSpeech =>
      'यसमा घृणित अभिव्यक्ति समावेश भएकोले अनुवाद गर्न सकिँदैन।';

  @override
  String get errorSexualContent =>
      'यसमा कामुक सामग्री समावेश भएकोले अनुवाद गर्न सकिँदैन।';

  @override
  String get errorOtherSafety => 'AI सुरक्षा नीतिले अनुवाद अस्वीकार गरेको छ।';

  @override
  String get clearAll => 'सबै खाली गर्नुहोस्';

  @override
  String get disambiguationTitle => 'अर्थ छनोट गर्नुहोस्';

  @override
  String get disambiguationPrompt => 'कुन अर्थमा अनुवाद गर्न चाहनुहुन्छ?';

  @override
  String get skip => 'छोड्नुहोस्';

  @override
  String get inputModeTitle => 'इनपुट';

  @override
  String get reviewModeTitle => 'समीक्षा';

  @override
  String get practiceModeTitle => 'अभ्यास';

  @override
  String get chatHistoryTitle => 'कुराकानी इतिहास';

  @override
  String get chatNew => 'नयाँ कुराकानी';

  @override
  String get chatNewChat => 'नयाँ कुराकानी';

  @override
  String get chatChoosePersona => 'व्यक्तित्व छान्नुहोस्';

  @override
  String get chatTypeHint => 'सन्देश टाइप गर्नुहोस्...';

  @override
  String chatFailed(Object error) {
    return 'च्याट असफल भयो: $error';
  }

  @override
  String get chatNoConversations => 'कुनै कुराकानी छैन';

  @override
  String get chatStartNewPrompt =>
      'अभ्यासको लागि नयाँ कुराकानी सुरु गर्नुहोस्!';

  @override
  String chatFromConversation(Object speaker) {
    return 'कुराकानीबाट उद्धरण ($speaker)';
  }

  @override
  String get personaTeacher => 'अंग्रेजी शिक्षक';

  @override
  String get personaGuide => 'यात्रा गाइड';

  @override
  String get personaFriend => 'स्थानीय साथी';

  @override
  String get chatUntitled => 'शीर्षक नभएको कुराकानी';

  @override
  String get chatAiChat => 'च्याट';

  @override
  String get tutorialAiChatTitle => 'एआई च्याट';

  @override
  String get tutorialAiChatDesc =>
      'AI व्यक्तित्वसँग वास्तविक कुराकानीको अभ्यास गर्नुहोस्।';

  @override
  String mode1SelectedMaterial(Object name) {
    return 'हाल चयन गरिएको सामग्री संग्रह: $name';
  }

  @override
  String get basicWordRepository => 'आधारभूत शब्द भण्डार';

  @override
  String get basicSentenceRepository => 'आधारभूत वाक्य भण्डार';

  @override
  String get chatEndTitle => 'कुराकानी अन्त्य र सुरक्षित';

  @override
  String get chatEndMessage => 'के तपाइँ कुराकानी अन्त्य गर्न चाहनुहुन्छ?';

  @override
  String get chatSaveAndExit => 'सुरक्षित गरेर बाहिर निस्कनुहोस्';

  @override
  String get errorSelectCategory => 'पहिले शब्द वा वाक्य छान्नुहोस्!';

  @override
  String get tutorialM1ToggleTitle => 'शब्द/वाक्य मोड';

  @override
  String get tutorialM1ToggleDesc =>
      'शब्द र वाक्य मोड यहाँबाट परिवर्तन गर्नुहोस्।';

  @override
  String get metadataDialogTitle => 'विस्तृत वर्गीकरण';

  @override
  String get tagFormal => 'आदरार्थी';

  @override
  String get selectPOS => 'पदको प्रकार छान्नुहोस्';

  @override
  String get selectSentenceType => 'वाक्यको प्रकार छान्नुहोस्';

  @override
  String get metadataRootWord => 'मूल शब्द (Root Word)';

  @override
  String get posNoun => 'संज्ञा';

  @override
  String get posVerb => 'क्रिया';

  @override
  String get posAdjective => 'विशेषण';

  @override
  String get posAdverb => 'क्रियाविशेषण';

  @override
  String get posPronoun => 'सर्वनाम';

  @override
  String get posPreposition => 'अव्यय/विभक्ति';

  @override
  String get posConjunction => 'संयोजक';

  @override
  String get posInterjection => 'विस्मयादिबोधक';

  @override
  String get typeStatement => 'विज्ञप्ति';

  @override
  String get typeQuestion => 'प्रश्न';

  @override
  String get typeExclamation => 'विस्मयादिबोधक';

  @override
  String get typeImperative => 'आज्ञा';

  @override
  String get labelNote => 'टिप्पणी';

  @override
  String get labelShowMemorized => 'सकिएको';

  @override
  String get titleTagSelection => 'शीर्षक ट्याग (संग्रह)';

  @override
  String get generalTags => 'सामान्य ट्यागहरू';

  @override
  String get tagSelection => 'ट्याग छनोट';

  @override
  String get metadataFormType => 'व्याकरण रूप';

  @override
  String get formInfinitive => 'मूल रूप/वर्तमान काल';

  @override
  String get formPast => 'भूतकाल';

  @override
  String get formPastParticiple => 'भूत कृदन्त';

  @override
  String get formPresentParticiple => 'वर्तमान कृदन्त (ing)';

  @override
  String get formPresent => 'वर्तमान काल';

  @override
  String get formThirdPersonSingular => 'तेस्रो व्यक्ति एकवचन';

  @override
  String get formPlural => 'बहुवचन';

  @override
  String get formSingular => 'एकवचन';

  @override
  String get caseSubject => 'कर्ता कारक';

  @override
  String get caseObject => 'कर्म कारक';

  @override
  String get casePossessive => 'सम्बन्ध कारक';

  @override
  String get casePossessivePronoun => 'सम्बन्धवाचक सर्वनाम';

  @override
  String get caseReflexive => 'निजवाचक सर्वनाम';

  @override
  String get formPositive => 'सकारात्मक';

  @override
  String get formComparative => 'तुलनात्मक';

  @override
  String get formSuperlative => 'उत्कृष्ट';

  @override
  String get searchConditions => 'खोज सर्तहरू';

  @override
  String recentNItems(int count) {
    return 'हालसालै सिर्जना गरिएका $count वटा हेर्नुहोस्';
  }

  @override
  String get startsWith => 'सुरु हुने अक्षर';

  @override
  String get reset => 'रिसेट गर्नुहोस्';

  @override
  String get participantRename => 'सहभागीको नाम परिवर्तन गर्नुहोस्';

  @override
  String get labelName => 'नाम';

  @override
  String get gender => 'लिङ्ग';

  @override
  String get language => 'भाषा';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get neutral => 'तटस्थ';

  @override
  String get chatAllConversations => 'सबै कुराकानीहरू';

  @override
  String get tabConversation => 'Conversation';

  @override
  String get confirmDeleteConversation =>
      'के तपाइँ यो कुराकानी मेटाउन निश्चित हुनुहुन्छ?\nमेटाइएको कुराकानी पुन: प्राप्त गर्न सकिँदैन।';

  @override
  String get notSelected => '- चयन गरिएको छैन -';

  @override
  String get myWordbook => 'मेरो शब्दकोश';

  @override
  String get mySentenceCollection => 'मेरो वाक्य संग्रह';

  @override
  String get newSubjectName => 'नयाँ विषयको नाम';

  @override
  String get enterNewSubjectName => 'नयाँ नाम प्रविष्ट गर्नुहोस्';

  @override
  String get addNewSubject => 'नयाँ नाम थप्नुहोस्';

  @override
  String get selectExistingSubject => 'अवस्थित नाम छान्नुहोस्';

  @override
  String get addTagHint => 'ट्याग थप्नुहोस्...';

  @override
  String get save => 'सुरक्षित गर्नुहोस्';
}
