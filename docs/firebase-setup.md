# Firebase Configuration Setup

## Security Notice

⚠️ **IMPORTANT**: Firebase API keys have been exposed in the repository and need to be rotated immediately.

## Immediate Action Required

### 1. Rotate Firebase API Keys
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new Firebase project or select your existing project
3. Go to Project Settings → General
4. In the "Your apps" section, add new apps or regenerate configuration for:
   - Android app
   - Web app
   - iOS app (if needed)

### 2. Revoke Exposed Keys
The following types of keys were previously exposed and have been removed:
- **API Keys**: All Firebase API keys
- **Project Configuration**: Firebase project identifiers
- **App IDs**: Platform-specific application identifiers

**Action Required**: Generate completely new Firebase project configuration.

### 3. Setup New Configuration

1. **Copy the template file**:
   ```bash
   cp lib/firebase_options.example.dart lib/firebase_options.dart
   ```

2. **Update with new credentials**:
   - Replace placeholder values in `lib/firebase_options.dart` with your new Firebase configuration
   - Get new configuration from Firebase Console → Project Settings → Your apps

3. **Verify .gitignore**:
   - Ensure `lib/firebase_options.dart` is in `.gitignore`
   - Never commit the actual configuration file

## Environment-Based Configuration (Recommended)

For better security, consider using environment variables:

### 1. Create environment configuration
```dart
// lib/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: const String.fromEnvironment('FIREBASE_WEB_API_KEY'),
        appId: const String.fromEnvironment('FIREBASE_WEB_APP_ID'),
        messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
        storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
        authDomain: const String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      );
    }
    
    // Android configuration
    return FirebaseOptions(
      apiKey: const String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
      appId: const String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
      messagingSenderId: const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
      storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    );
  }
}
```

### 2. Create .env file (add to .gitignore)
```env
FIREBASE_PROJECT_ID=your-new-project-id
FIREBASE_ANDROID_API_KEY=your-new-android-api-key
FIREBASE_WEB_API_KEY=your-new-web-api-key
FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
FIREBASE_STORAGE_BUCKET=your-storage-bucket
FIREBASE_AUTH_DOMAIN=your-auth-domain
```

### 3. Run with environment variables
```bash
flutter run --dart-define-from-file=.env
```

## Security Best Practices

1. **Never commit sensitive credentials**
2. **Use different Firebase projects for dev/staging/prod**
3. **Implement Firebase Security Rules**
4. **Enable Firebase App Check**
5. **Monitor Firebase usage and logs**
6. **Rotate keys regularly**

## Firebase Security Rules

Update your Firestore security rules to restrict access:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add more specific rules for your collections
  }
}
```

## Monitoring

1. **Enable Firebase Security Monitoring**
2. **Set up alerts for unusual activity**
3. **Review Firebase usage logs regularly**
4. **Monitor API key usage in Google Cloud Console**

## Recovery Checklist

- [ ] Rotated Firebase API keys
- [ ] Revoked old API keys in Google Cloud Console
- [ ] Updated local firebase_options.dart with new keys
- [ ] Verified .gitignore includes firebase_options.dart
- [ ] Tested app with new configuration
- [ ] Updated CI/CD pipelines with new keys
- [ ] Notified team members about the security incident
- [ ] Reviewed Firebase security rules
- [ ] Enabled additional security monitoring