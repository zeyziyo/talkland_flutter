import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fil'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nl'),
    Locale('no'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW')
  ];

  /// Application title
  ///
  /// In ko, this message translates to:
  /// **'Talkie'**
  String get appTitle;

  /// Review tab label with count
  ///
  /// In ko, this message translates to:
  /// **'복습 ({count})'**
  String tabReview(int count);

  /// Study material tab label with count
  ///
  /// In ko, this message translates to:
  /// **'학습 자료 ({count})'**
  String tabStudyMaterial(int count);

  /// Mode 2 title for help dialog
  ///
  /// In ko, this message translates to:
  /// **'복습'**
  String get mode2Title;

  /// Search mode label
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get search;

  /// Translate button
  ///
  /// In ko, this message translates to:
  /// **'번역'**
  String get translate;

  /// Listen/TTS button
  ///
  /// In ko, this message translates to:
  /// **'듣기'**
  String get listen;

  /// Save translation button
  ///
  /// In ko, this message translates to:
  /// **'데이터 저장'**
  String get saveData;

  /// Data saved status
  ///
  /// In ko, this message translates to:
  /// **'저장 완료'**
  String get saved;

  /// Delete button
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// Title for material metadata section
  ///
  /// In ko, this message translates to:
  /// **'자료 정보'**
  String get materialInfo;

  /// Cancel button
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// Confirm/OK button
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// Refresh button
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get refresh;

  /// Study records title with count
  ///
  /// In ko, this message translates to:
  /// **'학습 기록 ({count})'**
  String studyRecords(int count);

  /// Language filter label
  ///
  /// In ko, this message translates to:
  /// **'대상 언어 필터:'**
  String get targetLanguageFilter;

  /// Empty state message
  ///
  /// In ko, this message translates to:
  /// **'선택한 언어의 학습 기록이 없습니다'**
  String get noRecords;

  /// Instruction to save data
  ///
  /// In ko, this message translates to:
  /// **'검색 모드에서 번역을 저장해보세요'**
  String get saveTranslationsFromSearch;

  /// Show translation button
  ///
  /// In ko, this message translates to:
  /// **'보이기'**
  String get flip;

  /// Hide translation button
  ///
  /// In ko, this message translates to:
  /// **'숨기기'**
  String get hide;

  /// Delete record dialog title
  ///
  /// In ko, this message translates to:
  /// **'레코드 삭제'**
  String get deleteRecord;

  /// Delete confirmation message
  ///
  /// In ko, this message translates to:
  /// **'이 학습 기록을 삭제하시겠습니까?'**
  String get confirmDelete;

  /// Delete success message
  ///
  /// In ko, this message translates to:
  /// **'레코드가 삭제되었습니다'**
  String get recordDeleted;

  /// Delete error message
  ///
  /// In ko, this message translates to:
  /// **'삭제 실패: {error}'**
  String deleteFailed(String error);

  /// Import JSON button
  ///
  /// In ko, this message translates to:
  /// **'JSON 파일 불러오기'**
  String get importJsonFile;

  /// Import in progress
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중...'**
  String get importing;

  /// Import success title
  ///
  /// In ko, this message translates to:
  /// **'불러오기 완료'**
  String get importComplete;

  /// Import error title
  ///
  /// In ko, this message translates to:
  /// **'불러오기 실패'**
  String get importFailed;

  /// Imported file name
  ///
  /// In ko, this message translates to:
  /// **'파일: {fileName}'**
  String importFile(String fileName);

  /// Total import count
  ///
  /// In ko, this message translates to:
  /// **'전체: {count}개'**
  String importTotal(int count);

  /// Successfully imported count
  ///
  /// In ko, this message translates to:
  /// **'추가: {count}개'**
  String importAdded(int count);

  /// Skipped import count
  ///
  /// In ko, this message translates to:
  /// **'건너뜀: {count}개'**
  String importSkipped(int count);

  /// Error section label
  ///
  /// In ko, this message translates to:
  /// **'오류:'**
  String get errors;

  /// Error dialog title
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// Import error message
  ///
  /// In ko, this message translates to:
  /// **'파일 불러오기 실패:\\n{error}'**
  String importErrorMessage(String error);

  /// Study material selector label
  ///
  /// In ko, this message translates to:
  /// **'학습 자료 선택'**
  String get selectStudyMaterial;

  /// Subject label
  ///
  /// In ko, this message translates to:
  /// **'주제:'**
  String get subject;

  /// Source label
  ///
  /// In ko, this message translates to:
  /// **'출처:'**
  String get source;

  /// File label
  ///
  /// In ko, this message translates to:
  /// **'파일:'**
  String get file;

  /// Progress indicator
  ///
  /// In ko, this message translates to:
  /// **'진행률: {current} / {total}'**
  String progress(int current, int total);

  /// Empty state prompt
  ///
  /// In ko, this message translates to:
  /// **'JSON 파일을 불러와주세요'**
  String get importJsonFilePrompt;

  /// Selection prompt
  ///
  /// In ko, this message translates to:
  /// **'학습 자료를 선택하세요'**
  String get selectMaterialPrompt;

  /// Study complete button text
  ///
  /// In ko, this message translates to:
  /// **'학습 완료'**
  String get studyComplete;

  /// Mark study button text
  ///
  /// In ko, this message translates to:
  /// **'학습 표시'**
  String get markAsStudied;

  /// STT listening status
  ///
  /// In ko, this message translates to:
  /// **'듣는 중...'**
  String get listening;

  /// STT complete status
  ///
  /// In ko, this message translates to:
  /// **'인식 완료'**
  String get recognized;

  /// STT error message
  ///
  /// In ko, this message translates to:
  /// **'음성 인식 실패: {error}'**
  String recognitionFailed(String error);

  /// Checking for duplicates
  ///
  /// In ko, this message translates to:
  /// **'확인 중...'**
  String get checking;

  /// Translation in progress
  ///
  /// In ko, this message translates to:
  /// **'번역 중...'**
  String get translating;

  /// Translation done status
  ///
  /// In ko, this message translates to:
  /// **'번역 완료 (저장 필요)'**
  String get translationComplete;

  /// Existing translation loaded
  ///
  /// In ko, this message translates to:
  /// **'저장된 번역 불러옴'**
  String get translationLoaded;

  /// Translation error
  ///
  /// In ko, this message translates to:
  /// **'번역 실패: {error}'**
  String translationFailed(String error);

  /// Empty input warning
  ///
  /// In ko, this message translates to:
  /// **'번역할 텍스트를 입력하세요'**
  String get enterTextToTranslate;

  /// Save in progress
  ///
  /// In ko, this message translates to:
  /// **'저장 중...'**
  String get saving;

  /// Save error - no data
  ///
  /// In ko, this message translates to:
  /// **'저장할 번역이 없습니다'**
  String get noTranslationToSave;

  /// Save error message
  ///
  /// In ko, this message translates to:
  /// **'저장 실패: {error}'**
  String saveFailed(String error);

  /// TTS playing status
  ///
  /// In ko, this message translates to:
  /// **'재생 중...'**
  String get playing;

  /// TTS error - no text
  ///
  /// In ko, this message translates to:
  /// **'재생할 텍스트가 없습니다'**
  String get noTextToPlay;

  /// TTS error message
  ///
  /// In ko, this message translates to:
  /// **'재생 실패: {error}'**
  String playbackFailed(String error);

  /// Source language label
  ///
  /// In ko, this message translates to:
  /// **'원본 언어'**
  String get sourceLanguage;

  /// Target language label
  ///
  /// In ko, this message translates to:
  /// **'대상 언어'**
  String get targetLanguage;

  /// Duplicate detection title
  ///
  /// In ko, this message translates to:
  /// **'유사한 텍스트 발견'**
  String get similarTextFound;

  /// Use existing text button
  ///
  /// In ko, this message translates to:
  /// **'기존 텍스트 사용'**
  String get useExistingText;

  /// Create new entry button
  ///
  /// In ko, this message translates to:
  /// **'새 문장으로 진행'**
  String get createNew;

  /// Review count display
  ///
  /// In ko, this message translates to:
  /// **'복습 {count}회'**
  String reviewCount(int count);

  /// No description provided for @tabSpeaking.
  ///
  /// In ko, this message translates to:
  /// **'말하기'**
  String get tabSpeaking;

  /// No description provided for @speakingPractice.
  ///
  /// In ko, this message translates to:
  /// **'말하기 연습'**
  String get speakingPractice;

  /// No description provided for @intervalSeconds.
  ///
  /// In ko, this message translates to:
  /// **'간격: {seconds}초'**
  String intervalSeconds(int seconds);

  /// No description provided for @yourPronunciation.
  ///
  /// In ko, this message translates to:
  /// **'내 발음'**
  String get yourPronunciation;

  /// No description provided for @correctAnswer.
  ///
  /// In ko, this message translates to:
  /// **'정답'**
  String get correctAnswer;

  /// No description provided for @score.
  ///
  /// In ko, this message translates to:
  /// **'정확도: {score}%'**
  String score(String score);

  /// No description provided for @perfect.
  ///
  /// In ko, this message translates to:
  /// **'완벽해요!'**
  String get perfect;

  /// No description provided for @good.
  ///
  /// In ko, this message translates to:
  /// **'좋아요'**
  String get good;

  /// No description provided for @tryAgain.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get tryAgain;

  /// No description provided for @startPractice.
  ///
  /// In ko, this message translates to:
  /// **'연습 시작'**
  String get startPractice;

  /// No description provided for @stopPractice.
  ///
  /// In ko, this message translates to:
  /// **'연습 중지'**
  String get stopPractice;

  /// No description provided for @helpTitle.
  ///
  /// In ko, this message translates to:
  /// **'도움말 및 가이드'**
  String get helpTitle;

  /// No description provided for @helpTabModes.
  ///
  /// In ko, this message translates to:
  /// **'기능 소개'**
  String get helpTabModes;

  /// No description provided for @helpTabJson.
  ///
  /// In ko, this message translates to:
  /// **'JSON 형식'**
  String get helpTabJson;

  /// No description provided for @helpTabTour.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼'**
  String get helpTabTour;

  /// No description provided for @helpMode1Desc.
  ///
  /// In ko, this message translates to:
  /// **'음성을 인식하여 번역하고, 결과를 듣습니다. 새로운 표현을 익히기에 좋습니다.'**
  String get helpMode1Desc;

  /// No description provided for @helpMode1Details.
  ///
  /// In ko, this message translates to:
  /// **'• 언어 설정: 상단 번역 아이콘으로 언어 변경\n• 도움말: 상단 물음표 아이콘으로 사용법 가이드 확인\n• 음성 입력: 마이크 아이콘을 눌러 말하기/멈추기\n• 텍스트 입력: 직접 타이핑하여 입력 가능\n• 자동 검색: 입력 시 유사한 문장이 있으면 알림\n• 번역하기: \'번역\' 버튼으로 즉시 번역 실행\n• 듣기: 스피커 아이콘으로 원어/번역문 듣기 (TTS)\n• 저장: \'데이터 저장\' 버튼으로 학습 기록 저장\n• 초기화: \'지우기\' 버튼으로 입력 내용 삭제'**
  String get helpMode1Details;

  /// No description provided for @helpMode2Desc.
  ///
  /// In ko, this message translates to:
  /// **'저장된 문장을 복습합니다. 번역을 가리고 확인하며 복습 횟수를 기록하세요.'**
  String get helpMode2Desc;

  /// No description provided for @helpMode2Details.
  ///
  /// In ko, this message translates to:
  /// **'• 자료 선택: 상단 메뉴(점 3개) > \'학습 자료집 선택\'에서 자료 선택\n• 카드 뒤집기: \'보이기/숨기기\' 버튼으로 번역 확인\n• 듣기: \'듣기\' 버튼으로 해당 문장 다시 듣기\n• 학습 체크: 완료된 문장은 체크 표시 (V)\n• 삭제: 카드를 길게 누르면 삭제 다이얼로그 표시\n• 필터: 전체 기록 보기 또는 학습 자료별 정렬'**
  String get helpMode2Details;

  /// No description provided for @helpMode3Desc.
  ///
  /// In ko, this message translates to:
  /// **'학습 자료의 문장을 듣고 직접 말하는 연습을 합니다.'**
  String get helpMode3Desc;

  /// No description provided for @helpMode3Details.
  ///
  /// In ko, this message translates to:
  /// **'• 자료 선택: 상단 메뉴(점 3개) > \'학습 자료집 선택\'에서 연습할 자료 선택\n• 간격 조절: [-] [+] 버튼으로 문장 사이 대기 시간 설정 (3초~60초)\n• 시작/정지: 재생 버튼으로 쉐도잉 세션 제어\n• 말하기: 원어민 음성을 듣고 따라서 말하기\n• 피드백: 발음 정확도 점수(0~100) 및 색상 표시 (초록/주황/빨강)\n• 재시도: 인식 실패 시 재시도 버튼 사용'**
  String get helpMode3Details;

  /// No description provided for @helpJsonDesc.
  ///
  /// In ko, this message translates to:
  /// **'학습 자료를 가져오려면 다음과 같은 구조의 JSON 파일을 사용하세요:'**
  String get helpJsonDesc;

  /// No description provided for @helpTourDesc.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼을 시작하면 **하이라이트 원(Circle)**이 주요 기능을 안내해 드립니다.\n(예: 학습 카드를 **하이라이트 원**이 가리킬 때 길게 누르면 삭제할 수 있습니다.)'**
  String get helpTourDesc;

  /// No description provided for @startTutorial.
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼 시작'**
  String get startTutorial;

  /// No description provided for @tutorialMicTitle.
  ///
  /// In ko, this message translates to:
  /// **'음성 입력'**
  String get tutorialMicTitle;

  /// No description provided for @tutorialMicDesc.
  ///
  /// In ko, this message translates to:
  /// **'마이크 버튼을 눌러 음성으로 입력할 수 있습니다.'**
  String get tutorialMicDesc;

  /// No description provided for @tutorialTabDesc.
  ///
  /// In ko, this message translates to:
  /// **'여기서 원하는 학습 모드를 선택할 수 있습니다.'**
  String get tutorialTabDesc;

  /// No description provided for @tutorialTapToContinue.
  ///
  /// In ko, this message translates to:
  /// **'화면을 탭하여 계속'**
  String get tutorialTapToContinue;

  /// No description provided for @tutorialTransTitle.
  ///
  /// In ko, this message translates to:
  /// **'번역하기'**
  String get tutorialTransTitle;

  /// No description provided for @tutorialTransDesc.
  ///
  /// In ko, this message translates to:
  /// **'입력한 텍스트를 번역합니다.'**
  String get tutorialTransDesc;

  /// No description provided for @tutorialSaveTitle.
  ///
  /// In ko, this message translates to:
  /// **'저장하기'**
  String get tutorialSaveTitle;

  /// No description provided for @tutorialSaveDesc.
  ///
  /// In ko, this message translates to:
  /// **'번역된 결과를 학습 기록에 저장하세요.'**
  String get tutorialSaveDesc;

  /// No description provided for @tutorialM2SelectTitle.
  ///
  /// In ko, this message translates to:
  /// **'자료 선택 & 필터'**
  String get tutorialM2SelectTitle;

  /// No description provided for @tutorialM2SelectDesc.
  ///
  /// In ko, this message translates to:
  /// **'상단 메뉴(점 3개)를 눌러 학습할 자료를 선택하세요.'**
  String get tutorialM2SelectDesc;

  /// No description provided for @tutorialM2ListTitle.
  ///
  /// In ko, this message translates to:
  /// **'학습 목록'**
  String get tutorialM2ListTitle;

  /// No description provided for @tutorialM2ListDesc.
  ///
  /// In ko, this message translates to:
  /// **'이 카드를 길게 누르면(Long Click) 삭제할 수 있습니다. 저장된 문장을 확인하고 뒤집어보세요.'**
  String get tutorialM2ListDesc;

  /// No description provided for @tutorialM3SelectTitle.
  ///
  /// In ko, this message translates to:
  /// **'자료 선택'**
  String get tutorialM3SelectTitle;

  /// No description provided for @tutorialM3SelectDesc.
  ///
  /// In ko, this message translates to:
  /// **'상단 메뉴(점 3개)를 눌러 연습할 자료 세트를 선택하세요.'**
  String get tutorialM3SelectDesc;

  /// No description provided for @tutorialM3IntervalTitle.
  ///
  /// In ko, this message translates to:
  /// **'간격 설정'**
  String get tutorialM3IntervalTitle;

  /// No description provided for @tutorialM3IntervalDesc.
  ///
  /// In ko, this message translates to:
  /// **'문장 사이의 대기 시간을 조절합니다.'**
  String get tutorialM3IntervalDesc;

  /// No description provided for @tutorialM3StartTitle.
  ///
  /// In ko, this message translates to:
  /// **'연습 시작'**
  String get tutorialM3StartTitle;

  /// No description provided for @tutorialM3StartDesc.
  ///
  /// In ko, this message translates to:
  /// **'재생 버튼을 눌러 원어민 음성을 듣고 따라하세요.'**
  String get tutorialM3StartDesc;

  /// No description provided for @startWarning.
  ///
  /// In ko, this message translates to:
  /// **'주의'**
  String get startWarning;

  /// No description provided for @noVoiceDetected.
  ///
  /// In ko, this message translates to:
  /// **'목소리가 감지되지 않았어요'**
  String get noVoiceDetected;

  /// No description provided for @tooltipSearch.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get tooltipSearch;

  /// No description provided for @tooltipStudyReview.
  ///
  /// In ko, this message translates to:
  /// **'학습+복습'**
  String get tooltipStudyReview;

  /// No description provided for @tooltipSpeaking.
  ///
  /// In ko, this message translates to:
  /// **'말하기'**
  String get tooltipSpeaking;

  /// No description provided for @tooltipDecrease.
  ///
  /// In ko, this message translates to:
  /// **'감소'**
  String get tooltipDecrease;

  /// No description provided for @tooltipIncrease.
  ///
  /// In ko, this message translates to:
  /// **'증가'**
  String get tooltipIncrease;

  /// No description provided for @languageSettings.
  ///
  /// In ko, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @tutorialM2DropdownDesc.
  ///
  /// In ko, this message translates to:
  /// **'상단 메뉴를 통해 학습할 자료를 선택할 수 있습니다.'**
  String get tutorialM2DropdownDesc;

  /// No description provided for @tutorialM2ImportDesc.
  ///
  /// In ko, this message translates to:
  /// **'기기의 폴더에서 JSON 파일을 불러옵니다.'**
  String get tutorialM2ImportDesc;

  /// No description provided for @tutorialLangSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get tutorialLangSettingsTitle;

  /// No description provided for @tutorialLangSettingsDesc.
  ///
  /// In ko, this message translates to:
  /// **'번역할 원본 언어와 대상 언어를 설정합니다.'**
  String get tutorialLangSettingsDesc;

  /// No description provided for @copy.
  ///
  /// In ko, this message translates to:
  /// **'복사'**
  String get copy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In ko, this message translates to:
  /// **'클립보드에 복사되었습니다!'**
  String get copiedToClipboard;

  /// No description provided for @tutorialContextTitle.
  ///
  /// In ko, this message translates to:
  /// **'상황/문맥 태그'**
  String get tutorialContextTitle;

  /// No description provided for @tutorialContextDesc.
  ///
  /// In ko, this message translates to:
  /// **'같은 문장이라도 상황(예: 아침, 저녁)을 적어두면 별도로 저장할 수 있어요.'**
  String get tutorialContextDesc;

  /// No description provided for @thinkingTimeInterval.
  ///
  /// In ko, this message translates to:
  /// **'생각 시간 간격'**
  String get thinkingTimeInterval;

  /// No description provided for @thinkingTimeDesc.
  ///
  /// In ko, this message translates to:
  /// **'정답이 공개되기 전 생각할 시간입니다.'**
  String get thinkingTimeDesc;

  /// No description provided for @autoPlay.
  ///
  /// In ko, this message translates to:
  /// **'자동 재생'**
  String get autoPlay;

  /// No description provided for @timeUp.
  ///
  /// In ko, this message translates to:
  /// **'시간 초과!'**
  String get timeUp;

  /// No description provided for @gameModeTitle.
  ///
  /// In ko, this message translates to:
  /// **'게임 모드'**
  String get gameModeTitle;

  /// No description provided for @gameModeDesc.
  ///
  /// In ko, this message translates to:
  /// **'연습할 게임 모드를 선택하세요'**
  String get gameModeDesc;

  /// No description provided for @wordDefenseTitle.
  ///
  /// In ko, this message translates to:
  /// **'단어 디펜스'**
  String get wordDefenseTitle;

  /// No description provided for @wordDefenseDesc.
  ///
  /// In ko, this message translates to:
  /// **'적이 도착하기 전에 단어를 말해서 기지를 방어하세요.'**
  String get wordDefenseDesc;

  /// No description provided for @dialogueQuestTitle.
  ///
  /// In ko, this message translates to:
  /// **'대화 퀘스트'**
  String get dialogueQuestTitle;

  /// No description provided for @dialogueQuestDesc.
  ///
  /// In ko, this message translates to:
  /// **'상황극을 통해 대화 연습을 하세요. 적절한 답변을 선택하고 말해보세요.'**
  String get dialogueQuestDesc;

  /// No description provided for @labelType.
  ///
  /// In ko, this message translates to:
  /// **'종류:'**
  String get labelType;

  /// No description provided for @labelWord.
  ///
  /// In ko, this message translates to:
  /// **'단어'**
  String get labelWord;

  /// No description provided for @labelSentence.
  ///
  /// In ko, this message translates to:
  /// **'문장'**
  String get labelSentence;

  /// No description provided for @contextTagLabel.
  ///
  /// In ko, this message translates to:
  /// **'문맥/상황 (선택사항) - 예: 아침인사, 존댓말'**
  String get contextTagLabel;

  /// No description provided for @contextTagHint.
  ///
  /// In ko, this message translates to:
  /// **'나중에 구분하기 쉽도록 상황을 적어주세요'**
  String get contextTagHint;

  /// No description provided for @translationLimitExceeded.
  ///
  /// In ko, this message translates to:
  /// **'번역 한도 초과'**
  String get translationLimitExceeded;

  /// No description provided for @translationLimitMessage.
  ///
  /// In ko, this message translates to:
  /// **'일일 무료 번역(5회)을 모두 사용했습니다.\\n\\n광고를 보고 5회를 즉시 충전하시겠습니까?'**
  String get translationLimitMessage;

  /// No description provided for @watchAdAndRefill.
  ///
  /// In ko, this message translates to:
  /// **'광고 보고 충전 (+5회)'**
  String get watchAdAndRefill;

  /// No description provided for @translationRefilled.
  ///
  /// In ko, this message translates to:
  /// **'번역 횟수가 5회 충전되었습니다!'**
  String get translationRefilled;

  /// No description provided for @adLoading.
  ///
  /// In ko, this message translates to:
  /// **'광고를 불러오는 중입니다. 잠시 후 다시 시도해주세요.'**
  String get adLoading;

  /// No description provided for @reviewAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 복습'**
  String get reviewAll;

  /// Total records count
  ///
  /// In ko, this message translates to:
  /// **'총 {count}개의 기록 (전체 보기)'**
  String totalRecords(int count);

  /// No description provided for @filterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get filterAll;

  /// No description provided for @practiceWordsOnly.
  ///
  /// In ko, this message translates to:
  /// **'단어만 연습 (Words Only)'**
  String get practiceWordsOnly;

  /// No description provided for @resetPracticeHistory.
  ///
  /// In ko, this message translates to:
  /// **'연습 기록 초기화'**
  String get resetPracticeHistory;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도?'**
  String get retry;

  /// No description provided for @noStudyMaterial.
  ///
  /// In ko, this message translates to:
  /// **'학습 자료가 없습니다.'**
  String get noStudyMaterial;

  /// No description provided for @gameOver.
  ///
  /// In ko, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @playAgain.
  ///
  /// In ko, this message translates to:
  /// **'다시 하기'**
  String get playAgain;

  /// No description provided for @speakNow.
  ///
  /// In ko, this message translates to:
  /// **'말하세요! (Speak!)'**
  String get speakNow;

  /// No description provided for @scoreLabel.
  ///
  /// In ko, this message translates to:
  /// **'점수'**
  String get scoreLabel;

  /// No description provided for @viewOnlineGuide.
  ///
  /// In ko, this message translates to:
  /// **'온라인 가이드 보기'**
  String get viewOnlineGuide;

  /// No description provided for @getMaterials.
  ///
  /// In ko, this message translates to:
  /// **'자료 받기'**
  String get getMaterials;

  /// No description provided for @swapLanguages.
  ///
  /// In ko, this message translates to:
  /// **'언어 전환'**
  String get swapLanguages;

  /// No description provided for @next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;

  /// No description provided for @wordModeLabel.
  ///
  /// In ko, this message translates to:
  /// **'단어 모드'**
  String get wordModeLabel;

  /// No description provided for @accuracy.
  ///
  /// In ko, this message translates to:
  /// **'정확도'**
  String get accuracy;

  /// No description provided for @basicDefault.
  ///
  /// In ko, this message translates to:
  /// **'기본 (Default)'**
  String get basicDefault;

  /// No description provided for @basic.
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get basic;

  /// No description provided for @tutorialM3WordsTitle.
  ///
  /// In ko, this message translates to:
  /// **'단어 연습'**
  String get tutorialM3WordsTitle;

  /// No description provided for @tutorialM3WordsDesc.
  ///
  /// In ko, this message translates to:
  /// **'체크하면 저장된 단어만 연습합니다.'**
  String get tutorialM3WordsDesc;

  /// No description provided for @enterTextHint.
  ///
  /// In ko, this message translates to:
  /// **'번역할 텍스트를 입력하세요'**
  String get enterTextHint;

  /// No description provided for @micButtonTooltip.
  ///
  /// In ko, this message translates to:
  /// **'음성 인식 시작'**
  String get micButtonTooltip;

  /// No description provided for @menuHelp.
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get menuHelp;

  /// No description provided for @menuWebDownload.
  ///
  /// In ko, this message translates to:
  /// **'홈페이지에서 자료 받기'**
  String get menuWebDownload;

  /// No description provided for @menuDeviceImport.
  ///
  /// In ko, this message translates to:
  /// **'기기에서 자료 가져오기'**
  String get menuDeviceImport;

  /// No description provided for @menuSettings.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get menuSettings;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get languageSettingsTitle;

  /// No description provided for @sourceLanguageLabel.
  ///
  /// In ko, this message translates to:
  /// **'내 언어 (Source)'**
  String get sourceLanguageLabel;

  /// No description provided for @targetLanguageLabel.
  ///
  /// In ko, this message translates to:
  /// **'학습 언어 (Target)'**
  String get targetLanguageLabel;

  /// No description provided for @mode3Start.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get mode3Start;

  /// No description provided for @mode3Stop.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get mode3Stop;

  /// No description provided for @mode3Next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get mode3Next;

  /// No description provided for @mode3TryAgain.
  ///
  /// In ko, this message translates to:
  /// **'재시도'**
  String get mode3TryAgain;

  /// No description provided for @tutorialSwapDesc.
  ///
  /// In ko, this message translates to:
  /// **'내 언어와 학습 언어를 서로 바꿉니다.'**
  String get tutorialSwapDesc;

  /// No description provided for @recognizedText.
  ///
  /// In ko, this message translates to:
  /// **'인식된 발음:'**
  String get recognizedText;

  /// No description provided for @tutorialM3ResetTitle.
  ///
  /// In ko, this message translates to:
  /// **'기록 초기화'**
  String get tutorialM3ResetTitle;

  /// No description provided for @tutorialM3ResetDesc.
  ///
  /// In ko, this message translates to:
  /// **'진행 상황과 정확도 점수를 초기화하여 처음부터 다시 시작합니다.'**
  String get tutorialM3ResetDesc;

  /// No description provided for @menuSelectMaterialSet.
  ///
  /// In ko, this message translates to:
  /// **'학습 자료집 선택'**
  String get menuSelectMaterialSet;

  /// No description provided for @sectionWord.
  ///
  /// In ko, this message translates to:
  /// **'단어 섹션'**
  String get sectionWord;

  /// No description provided for @sectionSentence.
  ///
  /// In ko, this message translates to:
  /// **'문장 섹션'**
  String get sectionSentence;

  /// No description provided for @tabWord.
  ///
  /// In ko, this message translates to:
  /// **'단어'**
  String get tabWord;

  /// No description provided for @tabSentence.
  ///
  /// In ko, this message translates to:
  /// **'문장'**
  String get tabSentence;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['af', 'ar', 'bn', 'cs', 'da', 'de', 'el', 'en', 'es', 'fa', 'fi', 'fil', 'fr', 'gu', 'he', 'hi', 'hu', 'id', 'it', 'ja', 'kn', 'ko', 'ml', 'mr', 'ms', 'nl', 'no', 'pa', 'pl', 'pt', 'ro', 'ru', 'sv', 'sw', 'ta', 'te', 'th', 'tr', 'uk', 'ur', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af': return AppLocalizationsAf();
    case 'ar': return AppLocalizationsAr();
    case 'bn': return AppLocalizationsBn();
    case 'cs': return AppLocalizationsCs();
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fa': return AppLocalizationsFa();
    case 'fi': return AppLocalizationsFi();
    case 'fil': return AppLocalizationsFil();
    case 'fr': return AppLocalizationsFr();
    case 'gu': return AppLocalizationsGu();
    case 'he': return AppLocalizationsHe();
    case 'hi': return AppLocalizationsHi();
    case 'hu': return AppLocalizationsHu();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'kn': return AppLocalizationsKn();
    case 'ko': return AppLocalizationsKo();
    case 'ml': return AppLocalizationsMl();
    case 'mr': return AppLocalizationsMr();
    case 'ms': return AppLocalizationsMs();
    case 'nl': return AppLocalizationsNl();
    case 'no': return AppLocalizationsNo();
    case 'pa': return AppLocalizationsPa();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ro': return AppLocalizationsRo();
    case 'ru': return AppLocalizationsRu();
    case 'sv': return AppLocalizationsSv();
    case 'sw': return AppLocalizationsSw();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'ur': return AppLocalizationsUr();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
