# 🔐 Flet 키스토어를 Flutter에서 사용하기

## ✅ 완료된 작업

1. **키스토어 파일 복사 완료**: `upload-keystore.jks` → `android/app/`
2. **빌드 설정 완료**: `build.gradle.kts`에 서명 설정 추가
3. **템플릿 생성 완료**: `key.properties.template`

---

## 로컬에서 서명된 APK 빌드하기

### 1단계: key.properties 파일 생성

`android/key.properties` 파일을 생성하고 다음 내용 입력:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=app/upload-keystore.jks
```

> ⚠️ **중요**: Flet 프로젝트에서 사용한 **실제 비밀번호**를 입력하세요!

### 2단계: 서명된 APK 빌드

```bash
cd c:\FlutterProjects\talkland_flutter
flutter build apk --release
```

빌드 완료 후 APK 위치:
- `build/app/outputs/flutter-apk/app-release.apk`

---

## GitHub Actions에서 서명된 APK 빌드하기

### 1단계: GitHub Secrets 설정

1. GitHub 저장소 → **Settings** → **Secrets and variables** → **Actions**
2. **"New repository secret"** 클릭
3. 다음 Secrets 추가:

| Name | Value |
|------|-------|
| `KEYSTORE_PASSWORD` | 키스토어 비밀번호 |
| `KEY_PASSWORD` | 키 비밀번호 |
| `KEY_ALIAS` | `upload` |

### 2단계: Keystore를 Base64로 인코딩

PowerShell에서 실행:

```powershell
cd c:\FlutterProjects\talkland_flutter\android\app
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Out-File -FilePath keystore-base64.txt
```

생성된 `keystore-base64.txt` 파일 내용을 복사합니다.

### 3단계: Base64 Keystore를 GitHub Secret에 추가

GitHub Secrets에 추가:

| Name | Value |
|------|-------|
| `KEYSTORE_BASE64` | (위에서 복사한 Base64 문자열) |

### 4단계: GitHub Actions Workflow 업데이트

`.github/workflows/build-apk.yml` 파일을 다음과 같이 수정:

```yaml
name: Build Android APK

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    name: Build Flutter APK
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.5'
          channel: 'stable'
          cache: true
      
      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/upload-keystore.jks
      
      - name: Create key.properties
        run: |
          cat > android/key.properties << EOF
          storePassword=${{ secrets.KEYSTORE_PASSWORD }}
          keyPassword=${{ secrets.KEY_PASSWORD }}
          keyAlias=${{ secrets.KEY_ALIAS }}
          storeFile=app/upload-keystore.jks
          EOF
      
      - name: Flutter doctor
        run: flutter doctor -v
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build signed APK
        run: flutter build apk --release
      
      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: talkland-signed-apk
          path: build/app/outputs/flutter-apk/app-release.apk
          retention-days: 30
      
      - name: Create Release (on tag)
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v1
        with:
          files: build/app/outputs/flutter-apk/app-release.apk
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## 보안 주의사항

### ❌ Git에 커밋하면 안 되는 파일

`.gitignore`에 다음이 포함되어 있는지 확인:

```
# Keystore files
*.jks
*.keystore
android/key.properties
```

### ✅ Git에 커밋해도 되는 파일

- `android/key.properties.template` (비밀번호 없는 템플릿)
- `.github/workflows/build-apk.yml` (Secrets 참조만 있음)

---

## 왜 동일한 키스토어를 사용해야 하나요?

1. **앱 업데이트**: 기존 Flet 앱을 설치한 사용자가 Flutter 버전으로 업데이트 가능
2. **Google Play**: 동일한 패키지명(`com.talkland.talkland`)으로 업로드하려면 동일한 서명 필요
3. **보안**: 다른 사람이 같은 패키지명으로 앱을 배포하는 것을 방지

---

## 문제 해결

### ❌ 빌드 실패: "Keystore file not found"

**원인**: `key.properties` 파일이 없거나 경로가 잘못됨

**해결**:
```bash
# key.properties 파일 확인
cat android/key.properties

# keystore 파일 확인
ls android/app/upload-keystore.jks
```

### ❌ 빌드 실패: "Incorrect password"

**원인**: 잘못된 비밀번호

**해결**: Flet 프로젝트에서 사용한 비밀번호를 다시 확인

### ❌ GitHub Actions에서 Base64 디코딩 실패

**원인**: Base64 문자열에 공백이나 줄바꿈 포함

**해결**: `keystore-base64.txt`의 내용을 **줄바꿈 없이** 한 줄로 복사

---

## 요약

✅ Flet 키스토어를 Flutter에서 사용 가능
✅ 로컬 빌드: `key.properties` 파일만 생성하면 됨
✅ GitHub Actions: Secrets에 비밀번호와 Base64 keystore 추가
✅ 동일한 서명으로 앱 업데이트 가능
