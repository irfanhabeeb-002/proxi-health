# 🚀 Proxi Health - Secure Setup Guide

## 🔒 Security First Setup

This repository has been secured to prevent credential exposure. Follow these steps to set up your development environment safely.

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account
- Git

## 🛡️ Secure Firebase Configuration

### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing one
3. Enable required services (Authentication, Firestore, etc.)

### Step 2: Configure Android App
1. In Firebase Console → Project Settings → General
2. Add Android app with package name: `com.proxihealth.app`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

### Step 3: Configure Web App
1. Add Web app in Firebase Console
2. Copy the configuration

### Step 4: Set Up Flutter Configuration
```bash
# Copy template files
cp lib/firebase_options.example.dart lib/firebase_options.dart
cp android/app/google-services.example.json android/app/google-services.json
cp firebase.example.json firebase.json

# Edit the copied files with your actual Firebase configuration
# NEVER commit these files to version control!
```

### Step 5: Install Dependencies
```bash
flutter pub get
```

### Step 6: Run the App
```bash
flutter run
```

## 🔍 Security Checklist

Before committing any code, verify:

- [ ] `lib/firebase_options.dart` is in .gitignore
- [ ] `android/app/google-services.json` is in .gitignore  
- [ ] `firebase.json` is in .gitignore
- [ ] No API keys in your code
- [ ] No hardcoded credentials
- [ ] Environment variables used for sensitive data

## 📁 File Structure

```
proxi-health/
├── lib/
│   ├── firebase_options.dart          # ❌ Never commit (your config)
│   └── firebase_options.example.dart  # ✅ Safe template
├── android/app/
│   ├── google-services.json           # ❌ Never commit (your config)
│   └── google-services.example.json   # ✅ Safe template
├── firebase.json                      # ❌ Never commit (your config)
├── firebase.example.json              # ✅ Safe template
└── docs/
    └── firebase-setup.md              # ✅ Detailed setup guide
```

## 🚨 What NOT to Commit

Never commit files containing:
- API keys
- Project IDs
- App IDs
- Authentication tokens
- Database URLs
- Storage bucket names

## 🛠️ Development Workflow

1. **Clone the repository**
2. **Set up Firebase configuration** (using templates)
3. **Install dependencies**: `flutter pub get`
4. **Run the app**: `flutter run`
5. **Make your changes**
6. **Verify no secrets in commits**: `git diff --cached`
7. **Commit and push**

## 🔧 Environment Variables (Recommended)

For production deployments, use environment variables:

```bash
# .env (add to .gitignore)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
```

## 🆘 Need Help?

- Check [Firebase Setup Guide](docs/firebase-setup.md) for detailed instructions
- Review [Flutter Firebase Documentation](https://firebase.flutter.dev/)
- Ensure all sensitive files are in .gitignore

## ✅ Ready to Deploy

Your repository is now secure and ready for:
- ✅ GitHub commits
- ✅ Team collaboration  
- ✅ CI/CD pipelines
- ✅ Production deployment

**Remember**: Keep your Firebase configuration files local and never commit them!