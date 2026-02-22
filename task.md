# 기본 참가자 로직 직접 검증 (Unit Test)
- [x] **테스트 코드 작성**: 핵심 DB 로직 검증 코드 생성 완료 (`test/default_participants_test.dart`)
- [x] **테스트 실행**: `flutter test`를 통한 검증 완료 (All tests passed!)
- [x] **결과 분석**: 외래 키 제약 조건 위반 해결 확인 ✅
- [x] **최종 보고**: 사용자에게 직접적인 실무 테스트 결과 제시 완료

## [Phase 33] 클라우드 동기화 및 대화 검색 기능 안정화 (완료)
- [x] **검색 범위 분리 구현**: 목록(제목 검색) vs 대화 내부(내용 검색) UI 및 로직 분리 ✅
- [x] **기간 검색 로직 완전성 확보**: 날짜 필터링 경계값 오류 해결 및 시간대 처리 강화 ✅
- [x] **v15.0: Google 로그인 및 영구 계정 동기화**
    - [x] Google 로그인 패키지(`google_sign_in`) 추가 및 설정
    - [x] `SupabaseAuthService` 내 `signInWithGoogle` 구현
    - [x] 인증 상태 리스너(`onAuthStateChange`) 기반 자동 동기화 트리거 구축
    - [x] `ChatHistoryScreen` 내 '당겨서 새로고침' 및 구글 로그인 버튼 추가
    - [x] 재설치 후 데이터 복원 시나리오 검증 및 UI 피드백 개선
- [x] **전체 동기화(Restore) 강화**: 그룹 목록 로드 시 참여자 정보 선제적 동기화 로직 추가 ✅
- [x] **Data Visibility**: 목록에서 메시지 카운트 표시 및 복구 상태 알림 보강 ✅
- [x] **최종 통합 검증**: 재설치 시나리오 테스트 및 검색 기능 전수 조사 ✅
