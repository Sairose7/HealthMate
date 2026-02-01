# HealthMate 🏃‍♂️💧😴

HealthMate is a comprehensive health and fitness tracking application built with Flutter. It helps users track their daily steps, hydration, and sleep patterns, rewarding them with badges for achieving their goals.

## 🌟 Features

*   **Step Tracking**: Automatic step counting using device sensors (Pedometer).
*   **Hydration Tracking**: Log water intake with quick-add buttons and visual progress.
*   **Sleep Tracking**: Record sleep duration and quality.
*   **Gamification**: Earn badges for reaching daily and lifetime milestones.
*   **Offline-First**: All data is stored locally using SQLite, ensuring the app works without internet.
*   **Cloud Sync**: Seamlessly backs up data to Firebase Firestore when online.
*   **Cross-Platform**: Runs on Android, iOS, and Windows.

## 🛠️ Tech Stack

*   **Framework**: Flutter
*   **State Management**: Provider
*   **Local Database**: SQLite (`sqflite`)
*   **Cloud Backend**: Firebase (Firestore, Auth)
*   **Architecture**: MVVM (Model-View-ViewModel)

## 🚀 Getting Started

Follow these instructions to set up the project on your local machine.

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured.
*   [Git](https://git-scm.com/) installed.
*   [Firebase CLI](https://firebase.google.com/docs/cli) installed (`npm install -g firebase-tools`).

### 1. Clone the Repository

```bash
git clone https://github.com/prof-rdx/Healthmate-V2.git
cd Healthmate-V2
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration (CRITICAL ⚠️)

This project uses Firebase for cloud sync. You **MUST** configure it for your specific environment (especially for Windows/Web support) to generate the necessary `firebase_options.dart` file.

1.  **Login to Firebase:**
    ```bash
    firebase login
    ```

2.  **Activate FlutterFire CLI:**
    ```bash
    dart pub global activate flutterfire_cli
    ```

3.  **Configure the App:**
    Run the following command and follow the interactive prompts. Select the platforms you want to support (Android, iOS, Web, Windows).
    ```bash
    flutterfire configure
    ```
    *   Select your Firebase project (or create a new one).
    *   **IMPORTANT**: Ensure **Windows** is selected if you plan to run on desktop.

    This command will generate `lib/firebase_options.dart`. **Without this file, the app will crash on Windows/Web.**

### 4. Run the Application

**Android:**
Ensure an emulator is running or a device is connected.
```bash
flutter run
```

**Windows:**
```bash
flutter run -d windows
```

## 🧪 Running Tests

This project uses a comprehensive test suite including unit, widget, and integration tests.

### 1. Generate Mocks
Before running tests, ensure all mocks are generated. This is required because the project uses `mockito` and `build_runner`.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Run All Tests
To run the entire test suite:

```bash
flutter test
```

### 3. Run Specific Tests
You can run tests by directory or specific file:

**Run all Unit Tests (ViewModels):**
```bash
flutter test test/viewmodels
```

**Run all Widget Tests (Screens):**
```bash
flutter test test/screens
```

**Run Integration Tests:**
```bash
flutter test test/integration
```

**Run a Single Test File:**
```bash
flutter test test/viewmodels/steps_viewmodel_test.dart
```

## 📦 Building for Production

### Android

To build an APK for testing/sideloading:
```bash
flutter build apk --release
```
The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

To build an App Bundle (AAB) for the Play Store:
```bash
flutter build appbundle --release
```

### iOS (Mac Only)

To build for iOS, you need a Mac with Xcode installed.

1.  Open the project in Xcode:
    ```bash
    open ios/Runner.xcworkspace
    ```
2.  Configure your signing settings in Xcode.
3.  Build the IPA:
    ```bash
    flutter build ipa --release
    ```

## ❓ Troubleshooting

**Issue: "Firebase has not been correctly initialized" on Windows**
*   **Cause**: The `lib/firebase_options.dart` file is missing or does not contain Windows configuration.
*   **Fix**: Run `flutterfire configure` again and make sure to select "Windows" using the arrow keys and spacebar.

**Issue: "Android sdkmanager not found"**
*   **Fix**: Ensure your Android SDK Command-line Tools are installed via Android Studio SDK Manager.

## 📄 License

This project is licensed under the MIT License.
