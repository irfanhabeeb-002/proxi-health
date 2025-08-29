import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proxi_health/screens/auth/signup_screen.dart';
import 'package:proxi_health/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  runApp(const SimpleFirestoreApp());
}

class SimpleFirestoreApp extends StatelessWidget {
  const SimpleFirestoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proxi Health',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SignupScreen(),
    );
  }
}

