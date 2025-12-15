# iOS Configuration for Tweekracht Sociality

## Bundle Identifier Setup

### Step 1: Open Xcode
```bash
cd ios
open Runner.xcworkspace
```

### Step 2: Update Bundle Identifier
1. Select **Runner** in the left panel (project navigator)
2. Select **Runner** under TARGETS
3. Go to **General** tab
4. Update **Bundle Identifier** to:
   ```
   com.tweekracht.sociality
   ```

### Step 3: Update Display Name
1. Still in **General** tab
2. Change **Display Name** to:
   ```
   Tweekracht Sociality
   ```

### Step 4: Update Info.plist (if needed)
File location: `ios/Runner/Info.plist`

Add/Update these keys:
```xml
<key>CFBundleDisplayName</key>
<string>Tweekracht Sociality</string>
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
<key>CFBundleName</key>
<string>Tweekracht Sociality</string>
```

### Step 5: Camera Permission (for QR Scanner)
Add to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Tweekracht Sociality needs camera access to scan QR codes for joining games.</string>
```

## Verification
```bash
# Clean and rebuild
flutter clean
cd ios
pod install
cd ..
flutter run
```

Your app should now show "Tweekracht Sociality" on the home screen!
