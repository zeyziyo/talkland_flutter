# 🚀 GitHub에 푸시하고 APK 빌드하기

## 방법 1: 명령줄로 푸시하기 (추천)

### 1단계: GitHub에서 새 저장소 생성

1. https://github.com/new 방문
2. 저장소 이름 입력 (예: `talkland_flutter`)
3. Private 선택 (추천)
4. **중요**: "Add .gitignore" 와 "Add README" 체크 해제 ❌
5. "Create repository" 클릭

### 2단계: 원격 저장소 연결 및 푸시

GitHub에서 생성한 저장소 URL을 복사한 후 실행:

```bash
cd c:\FlutterProjects\talkland_flutter

# YOUR_USERNAME을 본인 GitHub 사용자명으로 변경
git remote add origin https://github.com/YOUR_USERNAME/talkland_flutter.git

# main 브랜치로 변경
git branch -M main

# GitHub에 푸시
git push -u origin main
```

### 3단계: GitHub Actions 빌드 확인

푸시 후 자동으로 APK 빌드가 시작됩니다!

1. GitHub 저장소 페이지에서 **"Actions"** 탭 클릭
2. 빌드 진행 상황 확인 (약 5-7분 소요)
3. 완료 후 **"Artifacts"** 섹션에서 `talkland-release-apk` 다운로드

---

## 방법 2: GitHub Desktop 사용 (GUI)

### 1단계: GitHub Desktop 설치
https://desktop.github.com/

### 2단계: 저장소 추가
1. GitHub Desktop 열기
2. File → Add Local Repository
3. `c:\FlutterProjects\talkland_flutter` 선택

### 3단계: GitHub에 게시
1. "Publish repository" 클릭
2. 이름 확인 및 Private 선택
3. "Publish repository" 클릭

---

## APK 다운로드 및 설치

### GitHub에서 APK 다운로드

1. GitHub 저장소 → **Actions** 탭
2. 최신 워크플로우 클릭 (녹색 ✅ 표시 확인)
3. 아래로 스크롤하여 **Artifacts** 섹션 찾기
4. **"talkland-release-apk"** 클릭하여 다운로드
5. ZIP 압축 해제 → `app-release.apk` 파일 확인

### Android 기기에 설치

**방법 A: 직접 전송**
1. APK 파일을 Google Drive, 이메일, Telegram 등으로 전송
2. Android 기기에서 다운로드
3. 파일 매니저에서 APK 파일 탭
4. "알 수 없는 앱 설치" 허용
5. 설치 완료!

**방법 B: USB 케이블 (ADB)**
```bash
# ADB 설치 후
adb install app-release.apk
```

---

## 빌드 트리거

빌드는 다음 경우에 자동 실행됩니다:

✅ `main` 브랜치에 푸시할 때
✅ Pull Request 생성 시
✅ 수동 실행 (Actions 탭 → "Run workflow")

---

## 문제 해결

### ❌ 빌드가 실패했어요
1. Actions 탭에서 실패한 워크플로우 클릭
2. 빨간색 X 표시된 단계 클릭
3. 로그 확인 및 오류 메시지 검토

### ⚠️ git push가 안 돼요
```bash
# 원격 저장소 확인
git remote -v

# 없다면 다시 추가
git remote add origin https://github.com/YOUR_USERNAME/talkland_flutter.git
```

### 🔒 Permission denied
- GitHub 사용자명/비밀번호 확인
- 또는 Personal Access Token 사용

---

## 자동 릴리스 (선택사항)

Git 태그를 푸시하면 GitHub Release가 자동 생성되고 APK가 첨부됩니다:

```bash
git tag v1.0.0
git push origin v1.0.0
```

그러면 https://github.com/YOUR_USERNAME/talkland_flutter/releases 에서 APK를 다운로드할 수 있습니다!
