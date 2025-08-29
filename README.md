# Proxi Health

A Flutter application for health monitoring and management.

## Getting Started

This project provides a comprehensive health monitoring solution with features for tracking patient data, health metrics, and providing insights for better healthcare management.

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase account for authentication and data storage

### Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd proxi-health
   ```

2. **Secure Setup** (Required)
   ```bash
   # Copy configuration templates
   cp lib/firebase_options.example.dart lib/firebase_options.dart
   cp android/app/google-services.example.json android/app/google-services.json
   
   # Edit the copied files with your Firebase configuration
   # See SETUP.md for detailed instructions
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

📖 **Detailed Setup**: See [SETUP.md](SETUP.md) for complete configuration instructions.

## 🔒 Security Notice

This repository is configured for secure development:
- ✅ All sensitive files are properly gitignored
- ✅ Template files provided for safe setup
- ✅ No credentials will be accidentally committed
- ✅ Ready for team collaboration

## Features

- Patient health data tracking
- Secure authentication
- Real-time health monitoring
- Data visualization and analytics

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/).
