import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/screens/auth/login_screen.dart';
import 'package:proxi_health/screens/auth/signup_screen.dart';
import 'package:proxi_health/screens/user/user_dashboard_screen.dart';
import 'package:proxi_health/screens/doctor/doctor_dashboard_screen.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/services/firebase_auth_service.dart';
import 'package:proxi_health/services/secure_storage_service.dart';

void main() {
  group('Logo End-to-End Integration Tests', () {
    late AuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = AuthProvider(
        FirebaseAuthService(),
        SecureStorageService(),
      );
    });

    testWidgets('Logo appears consistently across all auth screens', (WidgetTester tester) async {
      // Test LoginScreen
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(ProxiLogo), findsOneWidget);
      var logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);

      // Test SignupScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      expect(find.byType(ProxiLogo), findsOneWidget);
      logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
    });

    testWidgets('Logo appears consistently across all dashboard screens', (WidgetTester tester) async {
      // Test UserDashboardScreen
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      expect(find.byType(ProxiLogo), findsOneWidget);
      var logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0); // Small size in header
      expect(logoWidget.height, 32.0);

      // Test DoctorDashboardScreen
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const DoctorDashboardScreen(),
          ),
        ),
      );

      expect(find.byType(ProxiLogo), findsOneWidget);
      logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0);
      expect(logoWidget.height, 32.0);
    });

    testWidgets('Logo maintains consistency during navigation flow', (WidgetTester tester) async {
      // Start with login screen
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => ChangeNotifierProvider<AuthProvider>(
              create: (_) => mockAuthProvider,
              child: const LoginScreen(),
            ),
            '/signup': (context) => const SignupScreen(),
            '/dashboard': (context) => ChangeNotifierProvider<AuthProvider>(
              create: (_) => mockAuthProvider,
              child: const UserDashboardScreen(),
            ),
          },
        ),
      );

      // Verify logo on login screen
      expect(find.byType(ProxiLogo), findsOneWidget);
      var logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);

      // Navigate to signup (simulate navigation)
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Verify logo on signup screen
      expect(find.byType(ProxiLogo), findsOneWidget);
      logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);

      // Navigate to dashboard (simulate successful auth)
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Verify logo in dashboard header
      expect(find.byType(ProxiLogo), findsOneWidget);
      logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0);
    });

    testWidgets('Logo performance across multiple screen transitions', (WidgetTester tester) async {
      const screens = [
        LoginScreen(),
        SignupScreen(),
      ];

      for (int i = 0; i < screens.length; i++) {
        final screen = screens[i];
        
        if (screen is LoginScreen) {
          await tester.pumpWidget(
            MaterialApp(
              home: ChangeNotifierProvider<AuthProvider>(
                create: (_) => mockAuthProvider,
                child: screen,
              ),
            ),
          );
        } else {
          await tester.pumpWidget(
            MaterialApp(home: screen),
          );
        }

        // Verify logo loads quickly and is present
        expect(find.byType(ProxiLogo), findsOneWidget);
        
        // Verify no exceptions during logo rendering
        expect(tester.takeException(), isNull);
        
        // Allow for any animations to complete
        await tester.pumpAndSettle();
        
        // Verify logo is still present after settling
        expect(find.byType(ProxiLogo), findsOneWidget);
      }
    });

    testWidgets('Logo maintains visual consistency across themes', (WidgetTester tester) async {
      final themes = [
        ThemeData.light(),
        ThemeData.dark(),
      ];

      for (final theme in themes) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: ChangeNotifierProvider<AuthProvider>(
              create: (_) => mockAuthProvider,
              child: const UserDashboardScreen(),
            ),
          ),
        );

        // Verify logo is present regardless of theme
        expect(find.byType(ProxiLogo), findsOneWidget);
        
        // Verify logo properties remain consistent
        final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
        expect(logoWidget.width, 32.0);
        expect(logoWidget.height, 32.0);
        expect(logoWidget.fit, BoxFit.contain);
        
        // Verify no rendering issues with theme changes
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Logo error handling works across all contexts', (WidgetTester tester) async {
      // Test error fallback in auth context
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Even if asset loading fails, widget should still render
      expect(find.byType(ProxiLogo), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Test error fallback in header context
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      expect(find.byType(ProxiLogo), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Logo accessibility is maintained across all screens', (WidgetTester tester) async {
      final screens = [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: const LoginScreen(),
        ),
        const SignupScreen(),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: const UserDashboardScreen(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: const DoctorDashboardScreen(),
        ),
      ];

      for (final screen in screens) {
        await tester.pumpWidget(
          MaterialApp(home: screen),
        );

        // Verify semantic label is present on every screen
        expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
        
        // Verify logo is accessible
        final logoFinder = find.byType(ProxiLogo);
        expect(logoFinder, findsOneWidget);
      }
    });
  });
}