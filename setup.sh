#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Ask user for the new app name and package name
echo -e "${GREEN}Please enter the new app name:${NC}"
read NEW_APP_NAME

echo -e "${GREEN}Please enter the new package name (e.g., com.example.newapp):${NC}"
read NEW_PACKAGE_NAME

# Ensure valid input for package name (basic check)
if [[ ! "$NEW_PACKAGE_NAME" =~ ^[a-z][a-z0-9_]*\.[a-z][a-z0-9_]*\.[a-z][a-z0-9_]*$ ]]; then
    echo -e "${RED}Invalid package name format. Please use the format com.example.appname.${NC}"
    exit 1
fi

# 2. Ask user for Android SDK and Flutter SDK paths
echo -e "${GREEN}Please enter the path to the Android SDK:${NC}"
read ANDROID_SDK_PATH

echo -e "${GREEN}Please enter the path to the Flutter SDK:${NC}"
read FLUTTER_SDK_PATH

# 3. Replace app name in pubspec.yaml
echo -e "${YELLOW}Updating app name in pubspec.yaml...${NC}"
sed -i '' "s/name: .*/name: $NEW_APP_NAME/" pubspec.yaml

# 4. Replace Android app name and package
echo -e "${YELLOW}Updating Android configuration...${NC}"
sed -i '' "s/android:label=.*/android:label=\"$NEW_APP_NAME\"/" android/app/src/main/AndroidManifest.xml
sed -i '' "s/applicationId .*/applicationId \"$NEW_PACKAGE_NAME\"/" android/app/build.gradle
sed -i '' "s/<string name=\"app_name\">.*/<string name=\"app_name\">$NEW_APP_NAME<\/string>/" android/app/src/main/res/values/strings.xml

# 5. Replace iOS app name and package
echo -e "${YELLOW}Updating iOS configuration...${NC}"
sed -i '' "s/<key>CFBundleName<\/key>.*/<key>CFBundleName<\/key><string>$NEW_APP_NAME<\/string>/" ios/Runner/Info.plist
sed -i '' "s/<key>CFBundleDisplayName<\/key>.*/<key>CFBundleDisplayName<\/key><string>$NEW_APP_NAME<\/string>/" ios/Runner/Info.plist
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*/PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE_NAME;/" ios/Runner.xcodeproj/project.pbxproj

echo -e "${GREEN}App name and package updated successfully!${NC}"

# 6. Update local.properties for Android SDK and Flutter SDK paths
echo -e "${YELLOW}Updating local.properties with Android SDK and Flutter SDK paths...${NC}"

# Check if local.properties exists, if not create it
if [[ ! -f "android/local.properties" ]]; then
    echo -e "${YELLOW}local.properties file not found. Creating a new one...${NC}"
    touch android/local.properties
fi

# Update the paths in local.properties
echo "sdk.dir=$ANDROID_SDK_PATH" > android/local.properties
echo "flutter.sdk=$FLUTTER_SDK_PATH" >> android/local.properties

echo -e "${GREEN}local.properties updated successfully!${NC}"

# 7. Install Flutter dependencies
flutter pub get

# 8. (Optional) Generate code using build_runner if needed
if grep -q "build_runner" pubspec.yaml; then
    flutter pub run build_runner build --delete-conflicting-outputs
fi

# 9. Build the project
flutter clean
flutter build apk

echo -e "${GREEN}Setup complete. You can now run the app with 'flutter run'.${NC}"
