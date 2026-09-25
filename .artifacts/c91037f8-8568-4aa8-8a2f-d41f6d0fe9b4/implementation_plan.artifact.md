# Implementation Plan: Appwrite Integration & Android Setup

This plan covers the integration of Appwrite for authentication and the resolution of the Android environment issues to get the **KTDS** app running.

## User Review Required

> [!IMPORTANT]
> **Appwrite Configuration:** You will need to provide your Appwrite **Endpoint** and **Project ID**. I will use placeholders (`YOUR_PROJECT_ID`) for now.
> **Android SDK:** The previous installation failed due to a network TLS error. I will attempt to install the Platform and System Image again.

## Proposed Changes

### [Backend] Appwrite Integration

#### [NEW] [appwrite_provider.dart](file:///D:/Projects/dodsystem/lib/app/data/appwrite_provider.dart)
*   Initialize the `Client` with the project ID and endpoint.
*   Provide a singleton or factory for accessing the client.

#### [NEW] [auth_repository.dart](file:///D:/Projects/dodsystem/lib/features/auth/data/auth_repository.dart)
*   Implement `Account` interactions: `create` (register), `createEmailPasswordSession` (login), and `deleteSession` (logout).
*   Handle `AppwriteException` and map them to user-friendly messages.

#### [MODIFY] [splash_page.dart](file:///D:/Projects/dodsystem/lib/features/auth/presentation/splash_page.dart)
*   Replace the `Timer` with an async check for an existing Appwrite session.
*   Navigate to `PortalPage` if logged in, else `LoginPage`.

#### [MODIFY] [login_page.dart](file:///D:/Projects/dodsystem/lib/features/auth/presentation/login_page.dart)
*   Inject `AuthRepository`.
*   Replace mock delay with `authRepository.login`.

#### [MODIFY] [register_page.dart](file:///D:/Projects/dodsystem/lib/features/auth/presentation/register_page.dart)
*   Replace mock logic with `authRepository.register`.

---

### [Platform] Android & Running

#### [MODIFY] [AndroidManifest.xml](file:///D:/Projects/dodsystem/android/app/src/main/AndroidManifest.xml)
*   Add the required `CallbackActivity` for Appwrite authentication.

#### [ENV] Android Emulator
*   Retry `android sdk install` for `platforms/android-35` and `system-images/android-35/google_apis/x86_64`.
*   Create and start an emulator instance.

#### [ENV] Web SDK
*   Verify `flutter_web_sdk` location and resolve compilation errors.

## Verification Plan

### Automated Tests
*   Run `puro flutter test` to ensure existing widget tests still pass.

### Manual Verification
1.  **Run on Web:** Launch using `puro flutter run -d chrome`.
2.  **Auth Flow:** Verify "Login" (fails as expected without valid creds) and "Register" UI updates.
3.  **Emulator:** Verify the Android emulator starts and the app installs.
