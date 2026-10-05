# Rocketbot-App
Rocketbot app

## Building

Prerequisites: Flutter 3.47.0 / Dart 3.13 and JDK 17 for Gradle. Newer JDKs (for example JDK 27) fail plugin resolution, so point Flutter at a JDK 17 install:

```bash
flutter config --jdk-dir="/path/to/jdk-17/Contents/Home"
```

### Android

`permission_handler_android` 14.1.0 requires `compileSdk 37`. The Android SDK Manager publishes the platform as `platforms;android-37.0`, while AGP 8.12.1 looks for `android-37`, so create a local alias until AGP 9's `compileSdkMinor` is adopted:

```bash
sdkmanager "platforms;android-37.0"
ln -s "$ANDROID_SDK_ROOT/platforms/android-37.0" "$ANDROID_SDK_ROOT/platforms/android-37"
```

`flutter build apk --profile` is the working local gate. `flutter build apk --debug` currently fails on the pre-existing missing `android/app/src/debug/google-services.json`. Release builds need `android/app/src/release/google-services.json` and `android/key.properties`, injected as secrets.

### iOS

Requires CocoaPods 1.17.0. Run `pod install` in `ios/` (use `pod update` only for intentional upgrades).

This project is CocoaPods-based, but Flutter 3.47 enables Swift Package Manager by default. Disable it for builds; otherwise Flutter migrates the project to SPM and dirties `ios/Runner.xcodeproj`:

```bash
flutter config --no-enable-swift-package-manager
```

Alternatively, set the `FLUTTER_SWIFT_PACKAGE_MANAGER=false` environment variable.

`flutter build ios --no-codesign` is the local gate. Release builds need `ios/GoogleService-Info.plist` and signing secrets.

### CI

CI currently runs analyze and test only (`.github/workflows/app.yml`); native builds are a manual release step.
