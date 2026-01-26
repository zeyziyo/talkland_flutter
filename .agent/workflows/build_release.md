---
description: How to Deploy to GitHub Actions
---

// turbo-all

# 🚀 Deployment Protocol (CI/CD ONLY)

1. **Commit Changes**
   ```bash
   git add .
   git commit -m "chore: release new version"
   ```

2. **Push to Trigger Build**
   ```bash
   git push origin main
   ```

3. **Verify & Install**
   - Wait for GitHub Actions to complete.
   - Download `app-release.apk` from GitHub.
   - Uninstall old app -> Install new APK.

> **⚠️ WARNING**: NEVER run `flutter build` locally. Local builds are forbidden.
