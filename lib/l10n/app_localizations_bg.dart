// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get googleContinue => 'Google로 계속하기';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirmTitle => '로그아웃';

  @override
  String get logoutConfirmMessage => '현재 기기에서 로그아웃하시겠습니까?';

  @override
  String get syncingData => '데이터 동기화 중...';

  @override
  String get helpTitle => 'Помощ и ръководство';

  @override
  String get helpTabModes => 'Описание на режимите';

  @override
  String get helpTabJson => 'JSON формат';

  @override
  String get helpTabTour => 'Обиколка';

  @override
  String get helpMode1Desc =>
      'Разпознава глас, превежда и позволява да чуете резултата.';

  @override
  String get helpMode1Details =>
      '• Настройка на езика: Сменете езика, като докоснете иконите горе/долу\n• Превключване дума/изречение: Смяна на режима\n• Гласово въвеждане: Докоснете иконата на микрофон, за да започнете/спрете слушането\n• Въвеждане на текст: Въведете директно, за да преведете\n• Автоматично търсене: Открива подобни съществуващи изречения\n• Превод: Преведете незабавно, като докоснете бутона за превод\n• Слушане: Пуснете TTS с иконата на високоговорител\n• Запазване: Добавете запис с \'Запазване на данни\'\n• Изчистване: Нулиране на въвеждането';

  @override
  String get helpMode2Desc =>
      'Прегледайте запазени изречения и проверете запаметяването си с функцията за автоматично скриване.';

  @override
  String get helpMode2Details =>
      '• Избор на материали: Изберете конкретна колекция от материали или \'Преглед на всички\'\n• Обръщане на карта: Проверете превода с \'Показване/Скриване\' (автоматична проверка на обучението)\n• Слушане: Пуснете TTS на изречението\n• Завършено обучение: Маркирайте като завършено обучение с отметка (V)\n• Изтриване: Задръжте продължително картата, за да изтриете записа\n• Условия за търсене: Филтриране по таг, последни елементи, начална буква';

  @override
  String get helpMode3Desc =>
      'Практикувайте произношение, като слушате и повтаряте изречения (Shadowing).';

  @override
  String get helpMode3Details =>
      '• Избор на материали: Изберете колекцията от материали за учене\n• Настройка на интервала: Регулирайте времето за изчакване между изреченията с бутоните [-] [+](3 сек. ~ 60 сек.)\n• Старт/Стоп: Контролирайте сесията за засенчване\n• Говорене: Слушайте гласа и говорете след него\n• Обратна връзка: Показва оценка за точност (0-100) и цвят\n• Условия за търсене: Филтриране на целта за практика по таг, последни елементи, начална буква';

  @override
  String get helpModeChatDesc =>
      'Практикувайте разговорен език, като разговаряте с AI персонаж.';

  @override
  String get helpModeChatDetails =>
      '• AI чат: Практикувайте разговори, като говорите на вашия език\n• Множество персонажи: Можете да промените пола/езика/името на другия човек с менюто над балона на речта\n• Добавяне на партньор: Добавете нов партньор за разговор (Непознат) с бутона +\n• GPS: Ситуационна игра, базирана на текущото местоположение\n• Автоматично запазване: Автоматичен превод и запазване на съдържанието на разговора';

  @override
  String get helpJsonDesc =>
      'Следвайте този формат, за да импортирате учебни материали във формат JSON за режим 3:';

  @override
  String get helpDialogueImportDesc =>
      'Импортиране на цял набор от диалози като JSON файл.';

  @override
  String get helpDialogueImportDetails =>
      '• JSON структура: Използвайте масив `dialogues` вместо `entries`\n• Автоматично възстановяване: Заглавието на диалога, персонажите и реда на съобщенията се възстановяват.\n• Местоположение: Импортираните диалози се появяват в раздела „История“ на режима AI Chat.';

  @override
  String get helpTourDesc =>
      '**Кръгът с акцент** ще ви насочи към основните функции.\n(Напр.: Можете да го изтриете, като задържите картата, посочена от **Кръгът с акцент**.)';

  @override
  String get partnerMode => 'Режим „Партньор“';

  @override
  String get manual => 'Ръчно въвеждане';

  @override
  String get speaker => 'Говорител';

  @override
  String get switchToAi => 'Превключване към AI режим';

  @override
  String get switchToPartner => 'Превключване към режим „Партньор“';

  @override
  String get currentLocation => 'Текущо местоположение';

  @override
  String get location => 'Местоположение';

  @override
  String get partner => 'Партньор';

  @override
  String get me => 'Аз';

  @override
  String get currentMaterialLabel => 'Текущо избрана колекция от материали:';

  @override
  String get basicMaterialRepository => 'Основно хранилище на изречения/думи';

  @override
  String get word => 'Дума';

  @override
  String get sentence => 'Изречение';

  @override
  String get appTitle => 'Talkie';

  @override
  String tabReview(int count) {
    return 'Преглед ($count)';
  }

  @override
  String tabStudyMaterial(int count) {
    return 'Учебни материали ($count)';
  }

  @override
  String get mode2Title => 'Преглед';

  @override
  String get search => 'Търсене';

  @override
  String get translate => 'Превод';

  @override
  String get listen => 'Слушане';

  @override
  String get saveData => 'Запазване на данни';

  @override
  String get saved => 'Запазено';

  @override
  String get delete => 'Изтриване';

  @override
  String get materialInfo => 'Информация за материала';

  @override
  String get cancel => 'Отказ';

  @override
  String get confirm => 'Потвърждение';

  @override
  String get refresh => 'Обновяване';

  @override
  String studyRecords(int count) {
    return 'Записи за обучение ($count)';
  }

  @override
  String get targetLanguageFilter => 'Филтър за целеви език:';

  @override
  String get noRecords => 'Няма записи за обучение за избрания език';

  @override
  String get saveTranslationsFromSearch =>
      'Опитайте да запазите преводи от режим на търсене';

  @override
  String get flip => 'Показване';

  @override
  String get hide => 'Скриване';

  @override
  String get deleteRecord => 'Изтриване на запис';

  @override
  String get confirmDelete => 'Искате ли да изтриете този запис за обучение?';

  @override
  String get recordDeleted => 'Записът е изтрит';

  @override
  String deleteFailed(String error) {
    return 'Неуспешно изтриване: $error';
  }

  @override
  String get importJsonFile => 'Импортиране на JSON файл';

  @override
  String get importing => 'Импортиране...';

  @override
  String get importComplete => 'Импортирането завърши';

  @override
  String get importFailed => 'Неуспешно импортиране';

  @override
  String importFile(String fileName) {
    return 'Файл: $fileName';
  }

  @override
  String get addParticipant => '참가자 추가';

  @override
  String get editParticipant => '참가자 수정';

  @override
  String get labelRole => '역할';

  @override
  String get labelLangCode => '언어 코드 (예: en-US, ko-KR)';

  @override
  String get roleUser => '사용자';

  @override
  String get roleAi => 'AI';

  @override
  String get participantDeleted => '참가자가 삭제되었습니다.';

  @override
  String get confirmDeleteParticipant => '이 참가자를 삭제하시겠습니까?';

  @override
  String importTotal(int count) {
    return 'Общо: $count';
  }

  @override
  String importAdded(int count) {
    return 'Добавени: $count';
  }

  @override
  String importSkipped(int count) {
    return 'Пропуснати: $count';
  }

  @override
  String get errors => 'Грешки:';

  @override
  String get error => 'Грешка';

  @override
  String importErrorMessage(String error) {
    return 'Неуспешно импортиране на файла:\\n$error';
  }

  @override
  String get importDuplicateTitleError =>
      '동일한 제목의 자료가 이미 존재합니다. 제목을 변경한 후 다시 시도해주세요.';

  @override
  String get selectStudyMaterial => 'Избор на учебни материали';

  @override
  String get subject => 'Заглавие:';

  @override
  String get source => 'Източник:';

  @override
  String get file => 'Файл:';

  @override
  String progress(int current, int total) {
    return 'Напредък: $current / $total';
  }

  @override
  String get importJsonFilePrompt => 'Моля, импортирайте JSON файл';

  @override
  String get selectMaterialPrompt => 'Изберете учебен материал';

  @override
  String get studyComplete => 'Обучението завърши';

  @override
  String get markAsStudied => 'Маркиране като изучено';

  @override
  String get listening => 'Слушане...';

  @override
  String get recognized => 'Разпознато';

  @override
  String recognitionFailed(String error) {
    return 'Неуспешно разпознаване на глас: $error';
  }

  @override
  String get checking => 'Проверка...';

  @override
  String get translating => 'Превод...';

  @override
  String get translationComplete => 'Преводът завърши (трябва да се запази)';

  @override
  String get translationLoaded => 'Зареден запазен превод';

  @override
  String translationFailed(String error) {
    return 'Неуспешен превод: $error';
  }

  @override
  String get enterTextToTranslate => 'Въведете текст за превод';

  @override
  String get translationResultHint => 'Translation result - editable';

  @override
  String get saving => 'Запазване...';

  @override
  String get noTranslationToSave => 'Няма превод за запазване';

  @override
  String saveFailed(String error) {
    return 'Неуспешно запазване: $error';
  }

  @override
  String get playing => 'Пускане...';

  @override
  String get noTextToPlay => 'Няма текст за пускане';

  @override
  String playbackFailed(String error) {
    return 'Неуспешно пускане: $error';
  }

  @override
  String get sourceLanguage => 'Изходен език';

  @override
  String get targetLanguage => 'Целеви език';

  @override
  String get similarTextFound => 'Намерен подобен текст';

  @override
  String get useExistingText => 'Използване на съществуващ текст';

  @override
  String get createNew => 'Продължаване с ново изречение';

  @override
  String reviewCount(int count) {
    return 'Преглед $count пъти';
  }

  @override
  String get tabSpeaking => 'Говорене';

  @override
  String get speakingPractice => 'Практикуване на говорене';

  @override
  String intervalSeconds(int seconds) {
    return 'Интервал: $seconds сек.';
  }

  @override
  String get yourPronunciation => 'Вашето произношение';

  @override
  String get correctAnswer => 'Верен отговор';

  @override
  String score(String score) {
    return 'Точност: $score%';
  }

  @override
  String get perfect => 'Перфектно!';

  @override
  String get good => 'Добре';

  @override
  String get tryAgain => 'Опитайте отново';

  @override
  String get startPractice => 'Започване на практика';

  @override
  String get stopPractice => 'Спиране на практика';

  @override
  String get menuOnlineLibrary => 'Online Library';

  @override
  String get startTutorial => 'Започване на урок';

  @override
  String get menuTutorial => 'Tutorial';

  @override
  String get tutorialMicTitle => 'Гласово въвеждане';

  @override
  String get tutorialMicDesc =>
      'Можете да въвеждате с глас, като докоснете бутона на микрофона.';

  @override
  String get tutorialTabDesc =>
      'Можете да изберете желания режим на обучение тук.';

  @override
  String get tutorialTapToContinue => 'Докоснете екрана, за да продължите';

  @override
  String get tutorialTransTitle => 'Превод';

  @override
  String get tutorialTransDesc => 'Превежда въведения текст.';

  @override
  String get tutorialSaveTitle => 'Запазване';

  @override
  String get tutorialSaveDesc =>
      'Запазете преведения резултат в записите за обучение.';

  @override
  String get tutorialM2SelectTitle => 'Избор на материали';

  @override
  String get tutorialM2SelectDesc =>
      'Докоснете иконата на колекция от материали (📚) в горната лента на приложението, за да изберете материала, който да учите.';

  @override
  String get tutorialM3SelectDesc =>
      'Докоснете иконата на колекция от материали (📚) в горната лента на приложението, за да изберете материала, който да практикувате.';

  @override
  String get tutorialM2ListTitle => 'Списък за обучение';

  @override
  String get tutorialM2ListDesc =>
      'Можете да го изтриете, като задържите продължително тази карта (Long Click). Проверете запазените изречения и ги обърнете.';

  @override
  String get tutorialM3SelectTitle => 'Избор на материали';

  @override
  String get tutorialM3IntervalTitle => 'Настройка на интервала';

  @override
  String get tutorialM3IntervalDesc =>
      'Регулира времето за изчакване между изреченията.';

  @override
  String get tutorialM3StartTitle => 'Започване на практика';

  @override
  String get tutorialM3StartDesc =>
      'Слушайте гласа на носител на езика и говорете след него, като докоснете бутона за пускане.';

  @override
  String get startWarning => 'Внимание';

  @override
  String get noVoiceDetected => 'Не е открит глас';

  @override
  String get tooltipSearch => 'Търсене';

  @override
  String get tooltipStudyReview => 'Обучение+Преглед';

  @override
  String get tooltipSpeaking => 'Говорене';

  @override
  String get tooltipDecrease => 'Намаляване';

  @override
  String get tooltipIncrease => 'Увеличаване';

  @override
  String get languageSettings => 'Езикови настройки';

  @override
  String get tutorialM2DropdownDesc =>
      'Можете да изберете материала за учене чрез горното меню.';

  @override
  String get tutorialM2SearchDesc => '저장된 단어와 문장을 검색하여 빠르게 찾을 수 있습니다.';

  @override
  String get tutorialM2ImportDesc =>
      'Импортиране на JSON файл от папката на устройството.';

  @override
  String get tutorialLangSettingsTitle => 'Езикови настройки';

  @override
  String get tutorialLangSettingsDesc =>
      'Настройте изходния и целевия език за превод.';

  @override
  String get copy => 'Копиране';

  @override
  String get copiedToClipboard => 'Копирано в клипборда!';

  @override
  String get tutorialContextTitle => 'Таг за ситуация/контекст';

  @override
  String get tutorialContextDesc =>
      'Можете да го запазите отделно, като запишете ситуацията (напр. сутрин, вечер) дори за едно и също изречение.';

  @override
  String get thinkingTimeInterval => 'Playback Delay';

  @override
  String get thinkingTimeDesc =>
      'Време за размисъл преди разкриване на верния отговор.';

  @override
  String get autoPlay => 'Автоматично пускане';

  @override
  String get timeUp => 'Времето изтече!';

  @override
  String get gameModeTitle => 'Режим на игра';

  @override
  String get gameModeDesc => 'Изберете режим на игра, който да практикувате';

  @override
  String get wordDefenseTitle => 'Защита на думи';

  @override
  String get wordDefenseDesc =>
      'Защитете базата, като кажете думата, преди врагът да пристигне.';

  @override
  String get dialogueQuestTitle => 'Куест за диалог';

  @override
  String get dialogueQuestDesc =>
      'Практикувайте разговори чрез ролеви игри. Изберете подходящ отговор и го кажете.';

  @override
  String get translation => '번역';

  @override
  String get labelType => 'Тип:';

  @override
  String get labelWord => 'Дума';

  @override
  String get labelSentence => 'Изречение';

  @override
  String get contextTagLabel =>
      'Контекст/Ситуация (по избор) - напр. Добро утро, Официално';

  @override
  String get contextTagHint =>
      'Запишете ситуацията, за да ви е по-лесно да я разграничите по-късно';

  @override
  String get usageLimitTitle => 'Достигнат лимит';

  @override
  String get translationLimitExceeded => 'Превишен лимит за превод';

  @override
  String get translationLimitMessage =>
      'Използвахте всичките си безплатни дневни преводи (5 пъти).\\n\\nИскате ли незабавно да презаредите 5 пъти, като гледате реклама?';

  @override
  String get watchAdAndRefill =>
      'Презареждане чрез гледане на реклама (+5 пъти)';

  @override
  String get translationRefilled => 'Броят на преводите е презареден 5 пъти!';

  @override
  String get adLoading =>
      'Рекламата се зарежда. Моля, опитайте отново по-късно.';

  @override
  String get reviewAll => 'Преглед на всички';

  @override
  String totalRecords(int count) {
    return 'Общо $count записа (Преглед на всички)';
  }

  @override
  String get filterAll => 'Всички';

  @override
  String get practiceWordsOnly => 'Практикуване само на думи';

  @override
  String get resetPracticeHistory => 'Нулиране на историята на практиката';

  @override
  String get retry => 'Да опитате отново?';

  @override
  String get noStudyMaterial => 'Няма учебен материал.';

  @override
  String get gameOver => 'Game Over';

  @override
  String get playAgain => 'Играйте отново';

  @override
  String get speakNow => 'Говорете сега!';

  @override
  String get scoreLabel => 'Резултат';

  @override
  String get viewOnlineGuide => 'Преглед на онлайн ръководството';

  @override
  String get getMaterials => 'Получаване на материали';

  @override
  String get swapLanguages => 'Размяна на езици';

  @override
  String get next => 'Напред';

  @override
  String get wordModeLabel => 'Режим „Думи“';

  @override
  String get accuracy => 'Точност';

  @override
  String get basicDefault => 'Основен';

  @override
  String get basic => 'Основен';

  @override
  String get tutorialM3WordsTitle => 'Практикуване на думи';

  @override
  String get tutorialM3WordsDesc =>
      'Ако е отметнато, ще се практикуват само запазените думи.';

  @override
  String get enterTextHint => 'Въведете текст за превод';

  @override
  String get micButtonTooltip => 'Започване на разпознаване на глас';

  @override
  String get menuHelp => 'Помощ';

  @override
  String get menuWebDownload => 'Начална страница';

  @override
  String get menuDeviceImport => 'Импортиране на материали от устройството';

  @override
  String get menuSettings => 'Езикови настройки';

  @override
  String get basicWords => 'Основно хранилище на думи';

  @override
  String get basicSentences => 'Основно хранилище на изречения';

  @override
  String get selectMaterialSet => 'Избор на колекция от учебни материали';

  @override
  String get sectionWords => 'Думи';

  @override
  String get sectionSentences => 'Изречения';

  @override
  String get languageSettingsTitle => 'Езикови настройки';

  @override
  String get sourceLanguageLabel => 'Моят език (Източник)';

  @override
  String get targetLanguageLabel => 'Език за учене (Цел)';

  @override
  String get mode3Start => 'Старт';

  @override
  String get mode3Stop => 'Стоп';

  @override
  String get mode3Next => 'Напред';

  @override
  String get mode3TryAgain => 'Опитайте отново';

  @override
  String get tutorialM3ResetTitle => 'Нулиране на историята';

  @override
  String get tutorialSwapDesc => 'Разменя моя език и езика за учене.';

  @override
  String get recognizedText => 'Разпознато произношение:';

  @override
  String titleFormat(Object materialName, Object type) {
    return '$type: $materialName';
  }

  @override
  String get tutorialM3ResetDesc =>
      'Нулира напредъка и резултатите за точност, за да започне отначало.';

  @override
  String get menuSelectMaterialSet => 'Избор на колекция от учебни материали';

  @override
  String get sectionWord => 'Раздел „Дума“';

  @override
  String get sectionSentence => 'Раздел „Изречение“';

  @override
  String get tabWord => 'Дума';

  @override
  String get tabSentence => 'Изречение';

  @override
  String get errorProfanity => 'Не може да се преведе, защото съдържа ругатни.';

  @override
  String get errorHateSpeech =>
      'Не може да се преведе, защото съдържа език на омразата.';

  @override
  String get errorSexualContent =>
      'Не може да се преведе, защото съдържа сексуално съдържание.';

  @override
  String get errorOtherSafety =>
      'Преводът е отказан от политиката за безопасност на AI.';

  @override
  String get clearAll => 'Изчистване на всички';

  @override
  String get disambiguationTitle => 'Избор на значение';

  @override
  String get disambiguationPrompt => 'Какво значение искате да преведете?';

  @override
  String get skip => 'Пропускане';

  @override
  String get inputModeTitle => 'Въвеждане';

  @override
  String get reviewModeTitle => 'Преглед';

  @override
  String get practiceModeTitle => 'Практика';

  @override
  String get chatHistoryTitle => 'История на разговорите';

  @override
  String get chatNew => 'Нов разговор';

  @override
  String get chatNewChat => 'Нов разговор';

  @override
  String get chatChoosePersona => 'Избор на персонаж';

  @override
  String get chatTypeHint => 'Въведете съобщение...';

  @override
  String chatFailed(Object error) {
    return 'Неуспешен чат: $error';
  }

  @override
  String get chatNoConversations => 'Все още нямате разговори';

  @override
  String get noDialogueHistory => 'No dialogue history.';

  @override
  String get chatStartNewPrompt => 'Започнете нов разговор за практика!';

  @override
  String chatFromConversation(Object speaker) {
    return 'Откъс от разговор ($speaker)';
  }

  @override
  String get personaTeacher => 'Учител по английски';

  @override
  String get personaGuide => 'Туристически гид';

  @override
  String get personaFriend => 'Местен приятел';

  @override
  String get chatUntitled => 'Разговор без заглавие';

  @override
  String get chatAiChat => 'Чат';

  @override
  String get manageParticipants => 'Manage Participants';

  @override
  String get tutorialAiChatTitle => 'AI Чат';

  @override
  String get tutorialAiChatDesc =>
      'Практикувайте разговори в реални ситуации с AI персонаж.';

  @override
  String mode1SelectedMaterial(Object name) {
    return 'Текущо избрана колекция от материали: $name';
  }

  @override
  String get basicWordRepository => 'Основно хранилище на думи';

  @override
  String get basicSentenceRepository => 'Основно хранилище на изречения';

  @override
  String get chatEndTitle => 'Край и запазване на разговора';

  @override
  String get chatEndMessage => 'Искате ли да прекратите разговора?';

  @override
  String get chatSaveAndExit => 'Запазване и излизане';

  @override
  String get errorSelectCategory => 'Моля, първо изберете дума или изречение!';

  @override
  String get tutorialM1ToggleTitle => 'Режим „Думи/Изречения“';

  @override
  String get tutorialM1ToggleDesc =>
      'Превключвайте между режимите „Думи“ и „Изречения“ тук.';

  @override
  String get metadataDialogTitle => 'Подробна класификация';

  @override
  String get tagFormal => 'Официален';

  @override
  String get selectPOS => 'Избор на част на речта';

  @override
  String get selectSentenceType => 'Избор на тип изречение';

  @override
  String get metadataRootWord => 'Основна форма (Root Word)';

  @override
  String get posNoun => 'Съществително';

  @override
  String get posVerb => 'Глагол';

  @override
  String get posAdjective => 'Прилагателно';

  @override
  String get posAdverb => 'Наречие';

  @override
  String get posPronoun => 'Местоимение';

  @override
  String get posPreposition => 'Предлог/Следлог';

  @override
  String get posConjunction => 'Съюз';

  @override
  String get posInterjection => 'Междуметие';

  @override
  String get typeStatement => 'Декларативно изречение';

  @override
  String get typeQuestion => 'Въпросително изречение';

  @override
  String get typeExclamation => 'Възклицателно изречение';

  @override
  String get typeImperative => 'Заповедно изречение';

  @override
  String get labelNote => 'Бележка';

  @override
  String get labelShowMemorized => 'Завършени';

  @override
  String get titleTagSelection => 'Заглавен етикет (Колекция)';

  @override
  String get generalTags => 'Общи етикети';

  @override
  String get tagSelection => 'Избор на таг';

  @override
  String get metadataFormType => 'Граматична форма';

  @override
  String get formInfinitive => 'Инфинитив/Сегашно време';

  @override
  String get formPast => 'Минало време';

  @override
  String get formPastParticiple => 'Минало причастие';

  @override
  String get formPresentParticiple => 'Сегашно причастие (-ing)';

  @override
  String get formPresent => 'Сегашно време';

  @override
  String get formThirdPersonSingular => 'Трети човек единствено число';

  @override
  String get formPlural => 'Множествено число';

  @override
  String get formSingular => 'Единствено число';

  @override
  String get caseSubject => 'Именителен падеж';

  @override
  String get caseObject => 'Винителен падеж';

  @override
  String get casePossessive => 'Притежателен падеж';

  @override
  String get casePossessivePronoun => 'Притежателно местоимение';

  @override
  String get caseReflexive => 'Възвратно местоимение';

  @override
  String get formPositive => 'Положителна степен';

  @override
  String get formComparative => 'Сравнителна степен';

  @override
  String get formSuperlative => 'Превислителна степен';

  @override
  String get searchConditions => 'Условия за търсене';

  @override
  String recentNItems(int count) {
    return 'Показване на последните $count създадени';
  }

  @override
  String get startsWith => 'Започва с';

  @override
  String get reset => 'Нулиране';

  @override
  String get participantRename => 'Преименуване на участник';

  @override
  String get labelName => 'Име';

  @override
  String get gender => 'Пол';

  @override
  String get language => 'Език';

  @override
  String get male => 'Мъж';

  @override
  String get female => 'Жена';

  @override
  String get neutral => 'Неутрален';

  @override
  String get chatAllConversations => 'Всички разговори';

  @override
  String get tabConversation => 'Conversation';

  @override
  String get confirmDeleteConversation =>
      'Искате ли да изтриете този разговор?\nИзтритите разговори не могат да бъдат възстановени.';

  @override
  String get notSelected => '- Не е избрано -';

  @override
  String get myWordbook => 'Моят речник';

  @override
  String get mySentenceCollection => 'Моята колекция от изречения';

  @override
  String get newSubjectName => 'Заглавие на нов речник/фрази';

  @override
  String get enterNewSubjectName => 'Въведете ново заглавие';

  @override
  String get addNewSubject => 'Добавяне на ново заглавие';

  @override
  String get selectExistingSubject => 'Избор на съществуващо заглавие';

  @override
  String get addTagHint => 'Добавяне на етикет...';

  @override
  String get save => 'Запазване';

  @override
  String get styleFormal => '존댓말';

  @override
  String get styleInformal => '반말';

  @override
  String get stylePolite => '정중함';

  @override
  String get styleSlang => '슬랭/속어';

  @override
  String statusDownloading(Object name) {
    return '다운로드 중: $name...';
  }

  @override
  String statusImportSuccess(Object name) {
    return '$name 가져오기 완료';
  }

  @override
  String statusImportFailed(Object error) {
    return '가져오기 실패: $error';
  }
}
