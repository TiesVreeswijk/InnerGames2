# 📱 Tweekracht Sociality - App Naming Guide

## What Has Been Changed

### ✅ Automated Changes (Already Done)
- ✅ Package name in `pubspec.yaml`: `tweekracht_sociality`
- ✅ App title in `main.dart`: `Tweekracht Sociality`
- ✅ Description updated

### 📋 Manual Changes Required

You need to manually update these platform-specific files:

## iOS Configuration (5 minutes)

### Method 1: Using Xcode (Recommended)

```bash
cd ios
open Runner.xcworkspace
```

Then in Xcode:

1. **Select Runner** (left panel, blue icon)
2. **Select Runner target** (under TARGETS)
3. **General tab**:
   - Bundle Identifier: `com.tweekracht.sociality`
   - Display Name: `Tweekracht Sociality`
   - Version: `1.0.0`
   - Build: `1`

4. **Add Camera Permission**:
   - Select `Info.plist` in left panel
   - Add new row: `NSCameraUsageDescription`
   - Value: `Tweekracht Sociality needs camera access to scan QR codes for joining games.`

### Method 2: Manual Edit

Edit `ios/Runner/Info.plist`:

```xml
<dict>
    <key>CFBundleDisplayName</key>
    <string>Tweekracht Sociality</string>
    
    <key>CFBundleName</key>
    <string>Tweekracht Sociality</string>
    
    <key>NSCameraUsageDescription</key>
    <string>Tweekracht Sociality needs camera access to scan QR codes for joining games.</string>
    
    <!-- Rest of your Info.plist -->
</dict>
```

## Android Configuration (5 minutes)

### File 1: `android/app/build.gradle`

Find the `defaultConfig` section and update:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.tweekracht.sociality"  // ← CHANGE THIS
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### File 2: `android/app/src/main/AndroidManifest.xml`

Update the package and label:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.tweekracht.sociality">  <!-- ← CHANGE THIS -->
    
    <!-- Add permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature android:name="android.hardware.camera"/>
    <uses-feature android:name="android.hardware.camera.autofocus"/>
    
    <application
        android:label="Tweekracht Sociality"  <!-- ← CHANGE THIS -->
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Rest of manifest -->
    </application>
</manifest>
```

### File 3: `android/app/src/main/kotlin/MainActivity.kt`

If this file exists, update the package:

```kotlin
package com.tweekracht.sociality  // ← CHANGE THIS

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

### File 4: Create `android/app/src/main/res/values/strings.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Tweekracht Sociality</string>
</resources>
```

## Quick Setup Script

Run the automated script:

```bash
cd sociality_app
./rename_app.sh
```

This will:
- ✅ Update pubspec.yaml
- ✅ Update main.dart
- ✅ Clean and get dependencies
- 📋 Show you what to change manually

## Verification Steps

After making all changes:

```bash
# Clean everything
flutter clean

# Update dependencies
flutter pub get

# iOS: Update pods
cd ios
pod install
cd ..

# Run the app
flutter run
```

## Expected Results

### On iOS:
- Home screen shows: **Tweekracht Sociality**
- App name in Settings: **Tweekracht Sociality**
- Bundle ID: `com.tweekracht.sociality`

### On Android:
- App drawer shows: **Tweekracht Sociality**
- Package name: `com.tweekracht.sociality`

## Complete File Changes Checklist

- [ ] `pubspec.yaml` - package name
- [ ] `lib/main.dart` - app title
- [ ] `ios/Runner.xcworkspace` - bundle ID and display name (via Xcode)
- [ ] `ios/Runner/Info.plist` - display name and camera permission
- [ ] `android/app/build.gradle` - applicationId
- [ ] `android/app/src/main/AndroidManifest.xml` - package and label
- [ ] `android/app/src/main/kotlin/MainActivity.kt` - package (if exists)
- [ ] `android/app/src/main/res/values/strings.xml` - app name
- [ ] Run `flutter clean && flutter pub get`
- [ ] Run `cd ios && pod install && cd ..`
- [ ] Test app: `flutter run`

## Bundle Identifier Details

### Recommended Structure:
```
com.tweekracht.sociality
 │      │         │
 │      │         └── App name
 │      └── Company name
 └── Reverse domain
```

### Alternative Options (if needed):
- `com.tweekracht.sociality`
- `nl.tweekracht.sociality` (if you have a .nl domain)
- `io.tweekracht.sociality`

**Use the same bundle ID for both iOS and Android!**

## App Store Requirements

When publishing to app stores, you'll need:

### Apple App Store:
- Bundle ID: `com.tweekracht.sociality`
- App Name: `Tweekracht Sociality`
- Apple Developer Account required

### Google Play Store:
- Package Name: `com.tweekracht.sociality`
- App Name: `Tweekracht Sociality`
- Google Play Console account required

## Common Issues

### Issue: "Bundle Identifier is already in use"
**Solution:** Choose a different bundle ID:
- `com.tweekracht.sociality.app`
- `com.tweekracht.socialityapp`

### Issue: "Could not determine bundle identifier"
**Solution:** Open in Xcode and set it there:
```bash
cd ios
open Runner.xcworkspace
```

### Issue: Build fails after renaming
**Solution:**
```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter pub get
flutter run
```

## Quick Reference Commands

```bash
# Run automated script
./rename_app.sh

# Clean and rebuild
flutter clean
flutter pub get

# Update iOS pods
cd ios && pod install && cd ..

# Check configuration
flutter doctor -v

# Run app
flutter run

# Build for release
flutter build ios
flutter build apk
```

## Need Help?

Check these files for detailed instructions:
- `IOS_CONFIG.md` - iOS-specific setup
- `ANDROID_CONFIG.md` - Android-specific setup
- `README.md` - General project documentation

---

**After completing all steps, your app will be properly named "Tweekracht Sociality"!** 🎉
