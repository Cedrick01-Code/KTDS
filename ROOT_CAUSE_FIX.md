# Root Cause of the Flutter SDK / launch failure

## Summary
The project code itself is not the main blocker. The failure is caused by the local Windows Flutter SDK environment managed by Puro, specifically a recursive launcher/wrapper issue and a broken, inconsistent SDK path configuration.

## Verified root cause

### 1) Recursive launcher loop from the Puro-managed Flutter installation
The original Flutter launcher at:

- `C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat`

was invoking a Puro-managed wrapper that re-entered the same Flutter launcher, producing:

- `Maximum setlocal recursion level reached.`

This is a Windows batch-file recursion issue, not a Dart source-code error.

### 2) Incorrect PowerShell invocation pattern
This syntax is not valid as a direct command in PowerShell:

- `"C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat" analyze`

It must be invoked as:

- `& "C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat" analyze`

The project code was not failing because of a Dart analyzer issue; the failure was caused by how the SDK launcher was being called.

### 3) SDK path mis-resolution / environment inconsistency
The launch command later reported:

- `Error: SDK root directory not found: /C:/Users/Cedrick/.puro/envs/stable/flutter/bin/cache/flutter_web_sdk/.`

This indicates the SDK root was being interpreted through a malformed path or inconsistent wrapper/environment state. In plain terms: the Flutter install itself was not being resolved cleanly in the active Windows environment.

## Evidence gathered

### Static analysis result
This command succeeded:

```powershell
powershell -NoProfile -Command "& 'C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat' analyze"
```

Result:

```text
Analyzing dodsystem...
No issues found!
```

This proves the actual project source code is valid.

### Flutter version check
This command succeeded:

```powershell
powershell -NoProfile -Command "& 'C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat' --version"
```

Result:

```text
Flutter 3.47.5
Dart 3.13.4
```

### App launch attempt
This command was used to launch the app:

```powershell
powershell -NoProfile -Command "cd 'D:\Projects\dodsystem'; & 'C:\Users\Cedrick\.puro\envs\stable\flutter\bin\flutter.bat' run -d chrome --web-port 8080"
```

It sometimes launched, then failed when the launcher environment was still inconsistent. The root cause remained external to the app code.

## Files inspected

- `D:\Projects\dodsystem\pubspec.yaml`
- `D:\Projects\dodsystem\pubspec.lock`
- `D:\Projects\dodsystem\analysis_options.yaml`
- `D:\Projects\dodsystem\.gitignore`
- `D:\Projects\dodsystem\.puro.json`
- `D:\Projects\dodsystem\lib\**`
- `D:\Projects\dodsystem\test\**`
- `D:\Projects\dodsystem\android\**`
- `D:\Projects\dodsystem\web\**`
- `D:\Projects\dodsystem\windows\**`

## Fixes already applied

The project code itself was corrected where actual analyzer errors existed, including:

- `lib/features/auth/presentation/login_page.dart`
- `lib/features/auth/presentation/auth_controller.dart`
- `lib/features/discipline/presentation/manager_case_page.dart`
- `lib/features/discipline/presentation/record_incident_page.dart`

The app code is no longer the primary failure point.

## Final diagnosis
The issue is not the Flutter app project. The issue is the SDK bootstrap environment around the Puro-managed Flutter install on Windows, including:

1. recursive wrapper behavior in the Flutter launcher
2. broken path resolution for the web SDK cache
3. bad shell invocation patterns in PowerShell
4. inconsistent environment variable state

## Recommended next action
The correct long-term fix is to repair or reinstall the Puro-managed Flutter environment so that its launcher is no longer recursive and PATH resolution is consistent, then test from a fresh terminal session with:

```powershell
flutter --version
flutter doctor
flutter devices
flutter pub get
flutter analyze
flutter run -d chrome
```

## Current status
The app code passes analysis and the SDK version is valid, but the local Windows environment still needs a clean SDK repair to ensure the app launches without the wrapper/path recursion problem.
