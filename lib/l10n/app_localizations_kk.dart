// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get googleContinue => 'Continue with Google';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to logout from this device?';

  @override
  String get syncingData => 'Syncing data...';

  @override
  String get helpTitle => 'Анықтама & Нұсқаулық';

  @override
  String get helpTabModes => 'Режимдерді түсіндіру';

  @override
  String get helpTabJson => 'JSON форматы';

  @override
  String get helpTabTour => 'Тәжірибе жасау';

  @override
  String get helpMode1Desc =>
      'Дауысты танып, аударып, нәтижесін тыңдай аласыз.';

  @override
  String get helpMode1Details =>
      '• Тілді орнату: тілді өзгерту үшін жоғарғы/төменгі белгішені басыңыз\n• Сөз/сөйлем ауыстырып қосқышы: режимді ауыстыру\n• Дауыс енгізу: тыңдауды бастау/тоқтату үшін микрофон белгішесін басыңыз\n• Мәтін енгізу: аудару үшін тікелей теріңіз\n• Автоматты іздеу: ұқсас бар сөйлемді анықтау\n• Аударма: бірден аудару үшін аудару батырмасын басыңыз\n• Тыңдау: TTS ойнату үшін динамик белгішесін пайдаланыңыз\n• Сақтау: \'Деректерді сақтау\' арқылы жазба қосыңыз\n• Тазалау: енгізуді бастапқы күйге келтіру';

  @override
  String get helpMode2Desc =>
      'Сақталған сөйлемдерді қарап шығып, автоматты жасыру функциясы арқылы есте сақтау туралы біліңіз.';

  @override
  String get helpMode2Details =>
      '• Материалды таңдау: нақты материалды немесе \'Толық қарауды\' таңдаңыз\n• Картаны аудару: аударманы \'Көрсету/Жасыру\' арқылы тексеріңіз (автоматты оқытуды тексеру)\n• Тыңдау: сөйлемді TTS ойнату\n• Оқыту аяқталды: оқытуды аяқтау үшін құсбелгіні (V) пайдаланыңыз\n• Жою: жазбаны жою үшін картаны ұзақ басып тұрыңыз\n• Іздеу шарттары: тегтер, соңғы элементтер, басталатын әріптер арқылы сүзгілеу';

  @override
  String get helpMode3Desc =>
      'Сөйлемді тыңдап, қайталап (Shadowing) айту арқылы дауысталуды жаттықтырыңыз.';

  @override
  String get helpMode3Details =>
      '• Материалды таңдау: оқуға арналған материалды таңдау\n• Аралықты орнату: сөйлемдер арасындағы күту уақытын реттеу үшін [-] [+] батырмаларын пайдаланыңыз (3 секундтан 60 секундқа дейін)\n• Бастау/Тоқтату: Shadowing сеансын басқару\n• Сөйлеу: дауысты тыңдап, қайталап айтыңыз\n• Кері байланыс: дәлдік көрсеткіші (0-100) және түс дисплейі\n• Іздеу шарттары: тегтер, соңғы элементтер, басталатын әріптер арқылы жаттығу мақсатын сүзгілеу';

  @override
  String get helpModeChatDesc =>
      'AI персонасымен сөйлесіп, іс жүзіндегі сөйлеуді жаттықтырыңыз.';

  @override
  String get helpModeChatDetails =>
      '• AI чаты: сөйлесуді жаттықтыру үшін өз тіліңізде сөйлеңіз\n• Бірнеше Persona: сөйлесу көпіршігіндегі мәзір арқылы қарсыластың жынысын/тілін/атын өзгертуге болады\n• Серіктес қосу: жаңа сөйлесу серіктесін (+ батырмасы) қосу\n• GPS: ағымдағы орналасу негізіндегі жағдай\n• Автоматты сақтау: сөйлесу мазмұнын автоматты түрде аудару және сақтау';

  @override
  String get helpJsonDesc =>
      'Mode 3-те пайдалану үшін оқу материалын JSON файлы ретінде импорттау үшін келесі форматты орындаңыз:';

  @override
  String get helpJsonTypeDialogue => 'Dialogue';

  @override
  String get helpJsonTypeSentence => 'Sentence';

  @override
  String get helpJsonTypeWord => 'Word';

  @override
  String get helpDialogueImportDesc =>
      'Бүкіл диалогтар жинағын JSON файлы ретінде импорттау.';

  @override
  String get helpDialogueImportDetails =>
      '• JSON құрылымы: `entries` орнына `dialogues` массивін пайдаланыңыз\n• Автоматты қалпына келтіру: диалог атауы, Persona, хабар реті қалпына келтіріледі.\n• Орналасуы: импортталған диалогтар AI Chat режимінің \'Тарих\' қойындысында пайда болады.';

  @override
  String get helpTourDesc =>
      '**Ерекшеленген шеңбер** негізгі функцияларды көрсетеді.\n(Мысалы: **Ерекшеленген шеңбер** көрсеткен картаны жою үшін ұзақ басып тұруға болады.)';

  @override
  String get partnerMode => 'Серіктес режимі';

  @override
  String get manual => 'Қолмен енгізу';

  @override
  String get speaker => 'Дыбыстаушы';

  @override
  String get switchToAi => 'AI режиміне ауысу';

  @override
  String get switchToPartner => 'Серіктес режиміне ауысу';

  @override
  String get currentLocation => 'Ағымдағы орналасу';

  @override
  String get location => 'Орналасу';

  @override
  String get partner => 'Серіктес';

  @override
  String get me => 'Мен';

  @override
  String get currentMaterialLabel => 'Ағымдағы таңдалған материал:';

  @override
  String get basicMaterialRepository => 'Негізгі сөйлем/сөз сақтау орны';

  @override
  String get word => 'Сөз';

  @override
  String get sentence => 'Сөйлем';

  @override
  String get appTitle => 'Talkie';

  @override
  String tabReview(int count) {
    return 'Қайталау ($count)';
  }

  @override
  String tabStudyMaterial(int count) {
    return 'Оқу материалы ($count)';
  }

  @override
  String get mode2Title => 'Қайталау';

  @override
  String get search => 'Іздеу';

  @override
  String get translate => 'Аудару';

  @override
  String get listen => 'Тыңдау';

  @override
  String get saveData => 'Деректерді сақтау';

  @override
  String get saved => 'Сақтау аяқталды';

  @override
  String get delete => 'Жою';

  @override
  String get materialInfo => 'Материал туралы ақпарат';

  @override
  String get cancel => 'Болдырмау';

  @override
  String get confirm => 'Растау';

  @override
  String get refresh => 'Жаңарту';

  @override
  String studyRecords(int count) {
    return 'Оқу жазбалары ($count)';
  }

  @override
  String get targetLanguageFilter => 'Мақсатты тіл сүзгісі:';

  @override
  String get noRecords => 'Таңдалған тілде оқу жазбалары жоқ';

  @override
  String get saveTranslationsFromSearch =>
      'Іздеу режимінде аудармаларды сақтап көріңіз';

  @override
  String get flip => 'Көрсету';

  @override
  String get hide => 'Жасыру';

  @override
  String get deleteRecord => 'Жазбаны жою';

  @override
  String get confirmDelete => 'Бұл оқу жазбасын жойғыңыз келе ме?';

  @override
  String get recordDeleted => 'Жазба жойылды';

  @override
  String deleteFailed(String error) {
    return 'Жою сәтсіз аяқталды: $error';
  }

  @override
  String get importJsonFile => 'JSON файлын импорттау';

  @override
  String get importing => 'Импорттау...';

  @override
  String get importComplete => 'Импорттау аяқталды';

  @override
  String get importFailed => 'Импорттау сәтсіз аяқталды';

  @override
  String importFile(String fileName) {
    return 'Файл: $fileName';
  }

  @override
  String get addParticipant => 'Add Participant';

  @override
  String get editParticipant => 'Edit Participant';

  @override
  String get labelRole => 'Role';

  @override
  String get labelLangCode => 'Language Code (e.g. en-US, ko-KR)';

  @override
  String get roleUser => 'User';

  @override
  String get roleAi => 'AI';

  @override
  String get participantDeleted => 'Participant deleted.';

  @override
  String get confirmDeleteParticipant =>
      'Are you sure you want to delete this participant?';

  @override
  String importTotal(int count) {
    return 'Барлығы: $count';
  }

  @override
  String importAdded(int count) {
    return 'Қосылды: $count';
  }

  @override
  String importSkipped(int count) {
    return 'Өткізіп жіберілді: $count';
  }

  @override
  String get errors => 'Қателер:';

  @override
  String get error => 'Қате';

  @override
  String importErrorMessage(String error) {
    return 'Файлды импорттау сәтсіз аяқталды:\\n$error';
  }

  @override
  String get importDuplicateTitleError =>
      'A material with the same title already exists. Please change the title and try again.';

  @override
  String get selectStudyMaterial => 'Оқу материалын таңдау';

  @override
  String get subject => 'Тақырып:';

  @override
  String get source => 'Дереккөз:';

  @override
  String get file => 'Файл:';

  @override
  String progress(int current, int total) {
    return 'Прогресс: $current / $total';
  }

  @override
  String get importJsonFilePrompt => 'JSON файлын импорттаңыз';

  @override
  String get selectMaterialPrompt => 'Оқу материалын таңдаңыз';

  @override
  String get studyComplete => 'Оқу аяқталды';

  @override
  String get markAsStudied => 'Оқу белгісі';

  @override
  String get listening => 'Тыңдау...';

  @override
  String get recognized => 'Танылды';

  @override
  String recognitionFailed(String error) {
    return 'Дауысты тану сәтсіз аяқталды: $error';
  }

  @override
  String get checking => 'Тексеру...';

  @override
  String get translating => 'Аудару...';

  @override
  String get translationComplete => 'Аударма аяқталды (сақтау керек)';

  @override
  String get translationLoaded => 'Сақталған аударма жүктелді';

  @override
  String translationFailed(String error) {
    return 'Аударма сәтсіз аяқталды: $error';
  }

  @override
  String get enterTextToTranslate => 'Аударылатын мәтінді енгізіңіз';

  @override
  String get translationResultHint => 'Translation result - editable';

  @override
  String get voluntaryTranslations => 'Voluntary Translations';

  @override
  String get saving => 'Сақтау...';

  @override
  String get noTranslationToSave => 'Сақтайтын аударма жоқ';

  @override
  String saveFailed(String error) {
    return 'Сақтау сәтсіз аяқталды: $error';
  }

  @override
  String get playing => 'Ойнату...';

  @override
  String get noTextToPlay => 'Ойнататын мәтін жоқ';

  @override
  String playbackFailed(String error) {
    return 'Ойнату сәтсіз аяқталды: $error';
  }

  @override
  String get sourceLanguage => 'Бастапқы тіл';

  @override
  String get targetLanguage => 'Мақсатты тіл';

  @override
  String get similarTextFound => 'Ұқсас мәтін табылды';

  @override
  String get useExistingText => 'Бар мәтінді пайдалану';

  @override
  String get createNew => 'Жаңа сөйлеммен жалғастыру';

  @override
  String reviewCount(int count) {
    return '$count рет қайталау';
  }

  @override
  String get tabSpeaking => 'Сөйлеу';

  @override
  String get speakingPractice => 'Сөйлеу жаттығуы';

  @override
  String intervalSeconds(int seconds) {
    return 'Аралық: $seconds секунд';
  }

  @override
  String get yourPronunciation => 'Сіздің айтылуыңыз';

  @override
  String get correctAnswer => 'Дұрыс жауап';

  @override
  String score(String score) {
    return 'Дәлдік: $score%';
  }

  @override
  String get perfect => 'Керемет!';

  @override
  String get good => 'Жақсы';

  @override
  String get tryAgain => 'Қайтадан көріңіз';

  @override
  String get startPractice => 'Жаттығуды бастау';

  @override
  String get stopPractice => 'Жаттығуды тоқтату';

  @override
  String get menuOnlineLibrary => 'Online Library';

  @override
  String get startTutorial => 'Оқулықты бастау';

  @override
  String get menuTutorial => 'Tutorial';

  @override
  String get tutorialMicTitle => 'Дауысты енгізу';

  @override
  String get tutorialMicDesc =>
      'Дауыспен енгізу үшін микрофон батырмасын басуға болады.';

  @override
  String get tutorialTabDesc => 'Мұнда қалаған оқу режимін таңдауға болады.';

  @override
  String get tutorialTapToContinue => 'Жалғастыру үшін экранды түртіңіз';

  @override
  String get tutorialTransTitle => 'Аудару';

  @override
  String get tutorialTransDesc => 'Енгізілген мәтінді аударады.';

  @override
  String get tutorialSaveTitle => 'Сақтау';

  @override
  String get tutorialSaveDesc => 'Аударылған нәтижені оқу жазбасына сақтаңыз.';

  @override
  String get selectParticipants => 'Select Participants';

  @override
  String get loadingParticipants => 'Loading participants...';

  @override
  String get noParticipantsFound => 'No participants found.';

  @override
  String get noInternetWarningMic =>
      'No internet connection. Voice recognition may not work offline.';

  @override
  String get noInternetWarningTranslate =>
      'No internet connection. Translation is unavailable offline. Please use Review mode.';

  @override
  String get noMaterialsInCategory => 'No materials in this category.';

  @override
  String get onlineLibraryLoadFailed => 'Failed to load materials.';

  @override
  String get onlineLibraryCheckInternet =>
      'Please check your internet connection or try again later.';

  @override
  String get onlineLibraryNoMaterials => 'No materials found.';

  @override
  String get sendingMessage => '메시지 전송 중...';

  @override
  String get startChat => 'Start Chat';

  @override
  String get manageParticipants => 'Manage Participants';

  @override
  String get tutorialAiChatTitle => 'AI чат';

  @override
  String get tutorialAiChatDesc =>
      'AI Persona-мен нақты өмірлік сөйлесуді жаттықтырып көріңіз.';

  @override
  String get tutorialM2SelectTitle => 'Материалды таңдау';

  @override
  String get tutorialM2SelectDesc =>
      'Оқуға арналған материалды таңдау үшін жоғарғы қолданбалы тақтадағы материал белгішесін (📚) басыңыз.';

  @override
  String get tutorialM2ListTitle => 'Оқу тізімі';

  @override
  String get tutorialM2ListDesc =>
      'Егер осы картаны ұзақ басып тұрсаңыз (Ұзақ басу), оны жоюға болады. Сақталған сөйлемді тексеріп, аударыңыз.';

  @override
  String get tutorialM3SelectTitle => 'Материалды таңдау';

  @override
  String get tutorialM3SelectDesc =>
      'Жаттығуға арналған материалды таңдау үшін жоғарғы қолданбалы тақтадағы материал белгішесін (📚) басыңыз.';

  @override
  String get tutorialM3IntervalTitle => 'Аралықты орнату';

  @override
  String get tutorialM3IntervalDesc =>
      'Сөйлемдер арасындағы күту уақытын реттейді.';

  @override
  String get tutorialM3StartTitle => 'Жаттығуды бастау';

  @override
  String get tutorialM3StartDesc =>
      'Түпнұсқа тілде дыбысты тыңдау және қайталау үшін ойнату батырмасын басыңыз.';

  @override
  String get startWarning => 'Ескерту';

  @override
  String get noVoiceDetected => 'Дауыс анықталмады';

  @override
  String get tooltipSearch => 'Іздеу';

  @override
  String get tooltipStudyReview => 'Оқу+Қайталау';

  @override
  String get tooltipSpeaking => 'Сөйлеу';

  @override
  String get tooltipDecrease => 'Төмендету';

  @override
  String get tooltipIncrease => 'Арттыру';

  @override
  String get languageSettings => 'Тілдік параметрлер';

  @override
  String get tutorialM2DropdownDesc =>
      'Жоғарғы мәзір арқылы оқуға арналған материалды таңдауға болады.';

  @override
  String get tutorialM2SearchDesc =>
      'Search through your saved words and sentences.';

  @override
  String get tutorialM2ImportDesc =>
      'Құрылғы қалтасынан JSON файлын импорттайды.';

  @override
  String get tutorialLangSettingsTitle => 'Тілдік параметрлер';

  @override
  String get tutorialLangSettingsDesc =>
      'Аударылатын бастапқы тіл мен мақсатты тілді орнатады.';

  @override
  String get copy => 'Көшіру';

  @override
  String get copiedToClipboard => 'Буферге көшірілді!';

  @override
  String get tutorialContextTitle => 'Жағдай/Мәтін мәні тегі';

  @override
  String get tutorialContextDesc =>
      'Егер бір сөйлемнің өзінде жағдайды жазсаңыз (мысалы, таңертең, кешке), оны бөлек сақтауға болады.';

  @override
  String get thinkingTimeInterval => 'Playback Delay';

  @override
  String get thinkingTimeDesc => 'Жауап жарияланғанға дейін ойлану уақыты.';

  @override
  String get autoPlay => 'Автоматты ойнату';

  @override
  String get timeUp => 'Уақыт бітті!';

  @override
  String get gameModeTitle => 'Ойын режимі';

  @override
  String get gameModeDesc => 'Жаттығуға арналған ойын режимін таңдаңыз';

  @override
  String get wordDefenseTitle => 'Сөзді қорғау';

  @override
  String get wordDefenseDesc =>
      'Жау келмес бұрын сөзді айтып, базаны қорғаңыз.';

  @override
  String get dialogueQuestTitle => 'Диалог квесті';

  @override
  String get dialogueQuestDesc =>
      'Жағдайды көрсету арқылы диалогты жаттықтырыңыз. Тиісті жауапты таңдап, айтыңыз.';

  @override
  String get translation => 'Translation';

  @override
  String get labelType => 'Түрі:';

  @override
  String get labelWord => 'Сөз';

  @override
  String get labelSentence => 'Сөйлем';

  @override
  String get contextTagLabel =>
      'Мәтін мәні/Жағдай (міндетті емес) - Мысалы: таңғы сәлемдесу, сыпайы сөз';

  @override
  String get contextTagHint => 'Кейін ажырату оңай болу үшін жағдайды жазыңыз';

  @override
  String get usageLimitTitle => 'Шекке жетті';

  @override
  String get translationLimitExceeded => 'Аударма шегінен асып кетті';

  @override
  String get translationLimitMessage =>
      'Күнделікті тегін аударманы (5 рет) толығымен пайдаландыңыз.\\n\\nЖарнаманы көріп, 5 рет тез арада толтырғыңыз келе ме?';

  @override
  String get watchAdAndRefill => 'Жарнаманы көріп толтыру (+5 рет)';

  @override
  String get translationRefilled => 'Аударма саны 5 ретке толтырылды!';

  @override
  String get adLoading =>
      'Жарнама жүктелуде. Бірнеше секундтан кейін қайталап көріңіз.';

  @override
  String get reviewAll => 'Толық қайталау';

  @override
  String totalRecords(int count) {
    return 'Барлығы $count жазба (толық көру)';
  }

  @override
  String get filterAll => 'Барлығы';

  @override
  String get practiceWordsOnly => 'Тек сөздерді жаттықтыру';

  @override
  String get resetPracticeHistory => 'Жаттығу тарихын қалпына келтіру';

  @override
  String get retry => 'Қайтадан көру?';

  @override
  String get noStudyMaterial => 'Оқу материалы жоқ.';

  @override
  String get gameOver => 'Ойын аяқталды';

  @override
  String get playAgain => 'Қайтадан ойнау';

  @override
  String get speakNow => 'Қазір сөйлеңіз!';

  @override
  String get scoreLabel => 'Ұпай';

  @override
  String get viewOnlineGuide => 'Онлайн нұсқауды көру';

  @override
  String get getMaterials => 'Материалдарды алу';

  @override
  String get swapLanguages => 'Тілдерді ауыстыру';

  @override
  String get next => 'Келесі';

  @override
  String get wordModeLabel => 'Сөз режимі';

  @override
  String get accuracy => 'Дәлдік';

  @override
  String get basicDefault => 'Негізгі';

  @override
  String get basic => 'Негізгі';

  @override
  String get tutorialM3WordsTitle => 'Сөздерді жаттықтыру';

  @override
  String get tutorialM3WordsDesc =>
      'Егер белгілесеңіз, сақталған сөздерді ғана жаттықтырасыз.';

  @override
  String get enterTextHint => 'Аударылатын мәтінді енгізіңіз';

  @override
  String get micButtonTooltip => 'Дауысты тануды бастау';

  @override
  String get menuHelp => 'Анықтама';

  @override
  String get menuWebDownload => 'Веб-сайт';

  @override
  String get menuDeviceImport => 'Құрылғыдан материалды импорттау';

  @override
  String get menuSettings => 'Тілдік параметрлер';

  @override
  String get basicWords => 'Негізгі сөз сақтау орны';

  @override
  String get basicSentences => 'Негізгі сөйлем сақтау орны';

  @override
  String get selectMaterialSet => 'Оқу материалдарының жинағын таңдау';

  @override
  String get sectionWords => 'Сөздер';

  @override
  String get sectionSentences => 'Сөйлемдер';

  @override
  String get languageSettingsTitle => 'Тілдік параметрлер';

  @override
  String get sourceLanguageLabel => 'Менің тілім (Source)';

  @override
  String get targetLanguageLabel => 'Оқылатын тіл (Target)';

  @override
  String get mode3Start => 'Бастау';

  @override
  String get mode3Stop => 'Тоқтату';

  @override
  String get mode3Next => 'Келесі';

  @override
  String get mode3TryAgain => 'Қайта көру';

  @override
  String get tutorialM3ResetTitle => 'Тарихты қалпына келтіру';

  @override
  String get tutorialSwapDesc => 'Менің тілім мен оқылатын тілді ауыстырады.';

  @override
  String get recognizedText => 'Танылған айтылу:';

  @override
  String titleFormat(Object materialName, Object type) {
    return '$type: $materialName';
  }

  @override
  String get tutorialM3ResetDesc =>
      'Прогресс пен дәлдік көрсеткішін қалпына келтіріп, басынан бастаңыз.';

  @override
  String get menuSelectMaterialSet => 'Оқу материалдарының жинағын таңдау';

  @override
  String get sectionWord => 'Сөз бөлімі';

  @override
  String get sectionSentence => 'Сөйлем бөлімі';

  @override
  String get tabWord => 'Сөз';

  @override
  String get tabSentence => 'Сөйлем';

  @override
  String get errorProfanity =>
      'Балағат сөздер бар болғандықтан аудару мүмкін емес.';

  @override
  String get errorHateSpeech =>
      'Өшпенділік білдіретін сөздер бар болғандықтан аудару мүмкін емес.';

  @override
  String get errorSexualContent =>
      'Жалаңаштайтын мазмұны бар болғандықтан аудару мүмкін емес.';

  @override
  String get errorOtherSafety =>
      'AI қауіпсіздік саясатына байланысты аударуға рұқсат етілмеді.';

  @override
  String get clearAll => 'Барлығын тазалау';

  @override
  String get disambiguationTitle => 'Мағынаны таңдау';

  @override
  String get disambiguationPrompt => 'Қандай мағынада аударғыңыз келеді?';

  @override
  String get skip => 'Өткізіп жіберу';

  @override
  String get inputModeTitle => 'Енгізу';

  @override
  String get reviewModeTitle => 'Қайталау';

  @override
  String get practiceModeTitle => 'Жаттығу';

  @override
  String get chatHistoryTitle => 'Сөйлесу тарихы';

  @override
  String get chatNew => 'Жаңа сөйлесу';

  @override
  String get chatNewChat => 'Жаңа сөйлесу';

  @override
  String get chatChoosePersona => 'Persona таңдау';

  @override
  String get chatTypeHint => 'Хабарламаны енгізіңіз...';

  @override
  String chatFailed(Object error) {
    return 'Чат сәтсіз аяқталды: $error';
  }

  @override
  String get chatNoConversations => 'Әлі сөйлесулер жоқ';

  @override
  String get noDialogueHistory => 'No dialogue history.';

  @override
  String get chatStartNewPrompt =>
      'Жаттығу үшін жаңа сөйлесуді бастап көріңіз!';

  @override
  String chatFromConversation(Object speaker) {
    return 'Сөйлесуден үзінді ($speaker)';
  }

  @override
  String get personaTeacher => 'Ағылшын тілі мұғалімі';

  @override
  String get personaGuide => 'Саяхат нұсқаушысы';

  @override
  String get personaFriend => 'Жергілікті дос';

  @override
  String get chatUntitled => 'Атаусыз сөйлесу';

  @override
  String get chatAiChat => 'Чат';

  @override
  String mode1SelectedMaterial(Object name) {
    return 'Қазір таңдалған материал: $name';
  }

  @override
  String get basicWordRepository => 'Негізгі сөз сақтау орны';

  @override
  String get basicSentenceRepository => 'Негізгі сөйлем сақтау орны';

  @override
  String get chatEndTitle => 'Сөйлесуді аяқтау және сақтау';

  @override
  String get chatEndMessage => 'Сөйлесуді аяқтағыңыз келе ме?';

  @override
  String get chatSaveAndExit => 'Сақтап шығу';

  @override
  String get errorSelectCategory => 'Алдымен сөзді немесе сөйлемді таңдаңыз!';

  @override
  String get tutorialM1ToggleTitle => 'Сөз/Сөйлем режимі';

  @override
  String get tutorialM1ToggleDesc =>
      'Сөз бен сөйлем режимдерін мұнда ауыстырыңыз.';

  @override
  String get metadataDialogTitle => 'Толық жіктеу';

  @override
  String get tagFormal => 'Сыпайы сөз';

  @override
  String get selectPOS => 'Сөз таптарын таңдау';

  @override
  String get selectSentenceType => 'Сөйлем түрін таңдау';

  @override
  String get metadataRootWord => 'Түбір (Root Word)';

  @override
  String get posNoun => 'Зат есім';

  @override
  String get posVerb => 'Етістік';

  @override
  String get posAdjective => 'Сын есім';

  @override
  String get posAdverb => 'Үстеу';

  @override
  String get posPronoun => 'Есімдік';

  @override
  String get posPreposition => 'Предлог/Жалғау';

  @override
  String get posConjunction => 'Жалғаулық';

  @override
  String get posInterjection => 'Одағай';

  @override
  String get typeStatement => 'Хабарлы сөйлем';

  @override
  String get typeQuestion => 'Сұраулы сөйлем';

  @override
  String get typeExclamation => 'Лепті сөйлем';

  @override
  String get typeImperative => 'Бұйрықты сөйлем';

  @override
  String get labelNote => 'Ескертпе';

  @override
  String get labelShowMemorized => 'Аяқталған';

  @override
  String get titleTagSelection => 'Тақырып тегі (Материалдар жинағы)';

  @override
  String get generalTags => 'Жалпы тегтер';

  @override
  String get tagSelection => 'Тегті таңдау';

  @override
  String get metadataFormType => 'Грамматикалық форма';

  @override
  String get formInfinitive => 'Негізгі/Нақ осы шақ';

  @override
  String get formPast => 'Өткен шақ';

  @override
  String get formPastParticiple => 'Есімше';

  @override
  String get formPresentParticiple => 'Ауыспалы осы шақ (ing)';

  @override
  String get formPresent => 'Нақ осы шақ';

  @override
  String get formThirdPersonSingular => '3-жақ, жекеше';

  @override
  String get formPlural => 'Көпше';

  @override
  String get formSingular => 'Жекеше';

  @override
  String get caseSubject => 'Атау септік';

  @override
  String get caseObject => 'Барыс септік';

  @override
  String get casePossessive => 'Ілік септік';

  @override
  String get casePossessivePronoun => 'Тәуелдік есімдік';

  @override
  String get caseReflexive => 'Өздік есімдік';

  @override
  String get formPositive => 'Жай шырай';

  @override
  String get formComparative => 'Салыстырмалы шырай';

  @override
  String get formSuperlative => 'Күшейтпелі шырай';

  @override
  String get searchConditions => 'Іздеу шарттары';

  @override
  String recentNItems(int count) {
    return 'Жақында жасалған $count элементті көру';
  }

  @override
  String get startsWith => 'Басталатын әріптер';

  @override
  String get reset => 'Қалпына келтіру';

  @override
  String get participantRename => 'Қатысушының атын өзгерту';

  @override
  String get labelName => 'Аты';

  @override
  String get gender => 'Жынысы';

  @override
  String get language => 'Тілі';

  @override
  String get male => 'Еркек';

  @override
  String get female => 'Әйел';

  @override
  String get neutral => 'Бейтарап';

  @override
  String get chatAllConversations => 'Барлық сұхбаттар';

  @override
  String get tabConversation => 'Conversation';

  @override
  String get confirmDeleteConversation =>
      'Бұл сұхбатты жойғыңыз келе ме?\nЖойылған сұхбатты қалпына келтіру мүмкін емес.';

  @override
  String get notSelected => '- Тандалмаған -';

  @override
  String get myWordbook => 'меӊіӊ сөздігім';

  @override
  String get mySentenceCollection => 'меӊіӊ сөйлемдер жинағым';

  @override
  String get newSubjectName => 'Жаңа тақырыптың атауы';

  @override
  String get enterNewSubjectName => 'Жаңа атауды енгізіңіз';

  @override
  String get addNewSubject => 'Жаңа атауды қосу';

  @override
  String get selectExistingSubject => 'Бар атауды таңдау';

  @override
  String get addTagHint => 'Тег қосу...';

  @override
  String get save => 'Сақтау';

  @override
  String get styleFormal => 'Formal';

  @override
  String get styleInformal => 'Informal';

  @override
  String get stylePolite => 'Polite';

  @override
  String get styleSlang => 'Slang';

  @override
  String statusDownloading(Object name) {
    return 'Downloading: $name...';
  }

  @override
  String statusImportSuccess(Object name) {
    return '$name Imported Successfully';
  }

  @override
  String statusImportFailed(Object error) {
    return 'Import Failed: $error';
  }

  @override
  String get statusLoginSuccess => 'Login successful.';

  @override
  String statusLoginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get statusLoginCancelled => 'Login cancelled.';

  @override
  String get statusLoggingIn => 'Logging in with Google...';

  @override
  String get statusLogoutSuccess => 'Logged out.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get invalidEmail => 'Please enter a valid email.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get statusSigningUp => 'Signing up...';

  @override
  String statusSignUpFailed(Object error) {
    return 'Sign up failed: $error';
  }

  @override
  String get statusCheckEmail =>
      'Электрондық поштаңызды тексеріп, растауды аяқтаңыз.';

  @override
  String get emailAlreadyInUse => '이미 등록된 이메일입니다. 로그인하거나 비밀번호 찾기를 이용해주세요.';
}
