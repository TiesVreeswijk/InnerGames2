# Android Configuration for Tweekracht Sociality

## Package Name Setup

### Step 1: Update Package Name in build.gradle
File: `android/app/build.gradle`

Find and update:
```gradle
android {
    ...
    defaultConfig {
        applicationId "com.tweekracht.sociality"  // ← Update this
        ...
    }
}
```

### Step 2: Update App Name in AndroidManifest.xml
File: `android/app/src/main/AndroidManifest.xml`

Update the label:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.tweekracht.sociality">  <!-- ← Update this -->
    
    <application
        android:label="Tweekracht Sociality"  <!-- ← Update this -->
        ...>
```

### Step 3: Add Camera Permission (for QR Scanner)
In the same `AndroidManifest.xml`, add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>

<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

### Step 4: Update strings.xml (Optional)
File: `android/app/src/main/res/values/strings.xml`

Create if doesn't exist:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Tweekracht Sociality</string>
</resources>
```

### Step 5: Move Kotlin Files (if package structure exists)

If you have Kotlin files in:
```
android/app/src/main/kotlin/com/example/sociality_app/
```

Move them to:
```
android/app/src/main/kotlin/com/tweekracht/sociality/
```

And update the package declaration in `MainActivity.kt`:
```kotlin
package com.tweekracht.sociality

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

## Verification
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

Your app should now show "Tweekracht Sociality" in the app drawer!
