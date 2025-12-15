#!/bin/bash

# Tweekracht Sociality - App Rename Script
# This script helps automate the renaming process

echo "🎯 Tweekracht Sociality - App Configuration"
echo "============================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR=$(pwd)

echo "📍 Project directory: $PROJECT_DIR"
echo ""

# Step 1: Update pubspec.yaml
echo "${BLUE}Step 1: Updating pubspec.yaml...${NC}"
if [ -f "pubspec.yaml" ]; then
    sed -i '' 's/name: sociality_app/name: tweekracht_sociality/g' pubspec.yaml
    sed -i '' 's/description: A social interaction learning game app/description: Interactive storytelling game for social work education by Tweekracht Sociality/g' pubspec.yaml
    echo "${GREEN}✓ pubspec.yaml updated${NC}"
else
    echo "⚠️  pubspec.yaml not found"
fi
echo ""

# Step 2: Update main.dart
echo "${BLUE}Step 2: Updating main.dart...${NC}"
if [ -f "lib/main.dart" ]; then
    sed -i '' "s/title: 'Sociality'/title: 'Tweekracht Sociality'/g" lib/main.dart
    echo "${GREEN}✓ main.dart updated${NC}"
else
    echo "⚠️  lib/main.dart not found"
fi
echo ""

# Step 3: Android configuration
echo "${BLUE}Step 3: Checking Android configuration...${NC}"
if [ -f "android/app/build.gradle" ]; then
    echo "📱 Android build.gradle found"
    echo "   Please manually update applicationId to: com.tweekracht.sociality"
    echo "   File: android/app/build.gradle"
else
    echo "⚠️  Android files not found"
fi
echo ""

if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
    echo "📱 AndroidManifest.xml found"
    echo "   Please manually update package and label"
    echo "   File: android/app/src/main/AndroidManifest.xml"
else
    echo "⚠️  AndroidManifest.xml not found"
fi
echo ""

# Step 4: iOS configuration
echo "${BLUE}Step 4: Checking iOS configuration...${NC}"
if [ -d "ios" ]; then
    echo "🍎 iOS directory found"
    echo "   Please open Xcode and update:"
    echo "   1. Bundle Identifier: com.tweekracht.sociality"
    echo "   2. Display Name: Tweekracht Sociality"
    echo ""
    echo "   Run: cd ios && open Runner.xcworkspace"
else
    echo "⚠️  iOS directory not found"
fi
echo ""

# Step 5: Clean and get dependencies
echo "${BLUE}Step 5: Cleaning and updating dependencies...${NC}"
echo "Running flutter clean..."
flutter clean

echo "Running flutter pub get..."
flutter pub get

echo "${GREEN}✓ Dependencies updated${NC}"
echo ""

# Summary
echo "============================================"
echo "${GREEN}✓ Automated updates complete!${NC}"
echo ""
echo "📋 Manual steps remaining:"
echo ""
echo "For iOS:"
echo "  1. cd ios && open Runner.xcworkspace"
echo "  2. Update Bundle Identifier to: com.tweekracht.sociality"
echo "  3. Update Display Name to: Tweekracht Sociality"
echo "  See IOS_CONFIG.md for details"
echo ""
echo "For Android:"
echo "  1. Edit android/app/build.gradle"
echo "  2. Update applicationId to: com.tweekracht.sociality"
echo "  3. Edit android/app/src/main/AndroidManifest.xml"
echo "  4. Update package and label"
echo "  See ANDROID_CONFIG.md for details"
echo ""
echo "Then run: flutter run"
echo ""
