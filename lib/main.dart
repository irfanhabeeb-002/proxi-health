import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_project/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ⬅️ ADD THIS
import 'package:template_project/services/firebase_auth_service.dart';
import 'package:template_project/screens/auth/login_screen.dart';
import 'package:template_project/screens/doctor/doctor_dashboard_screen.dart';
import 'package:template_project/screens/user/user_dashboard_screen.dart';
import 'package:template_project/services/api_service.dart';
import 'package:template_project/services/secure_storage_service.dart';
import 'package:template_project/theme/theme.dart';
import 'package:template_project/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase with generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authProvider = AuthProvider(
    FirebaseAuthService(),
    SecureStorageService(),
  );
  await authProvider.initAuth();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
      ],
      child: const ProxiHealthApp(),
    ),
  );
}

class ProxiHealthApp extends StatelessWidget {
  const ProxiHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proxi-Health',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/user_dashboard': (context) => const UserDashboardScreen(),
        '/doctor_dashboard': (context) => const DoctorDashboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.authState) {
      case AuthState.authenticated:
        if (authProvider.user?.role == UserRole.user) {
          return const UserDashboardScreen();
        } else {
          return const DoctorDashboardScreen();
        }
      case AuthState.unauthenticated:
        return const LoginScreen();
      case AuthState.uninitialized:
      case AuthState.authenticating:
      default:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
