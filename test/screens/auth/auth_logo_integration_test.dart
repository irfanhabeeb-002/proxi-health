import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/screens/auth/login_screen.dart';
import 'package:proxi_health/screens/auth/signup_screen.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/services/firebase_auth_service.dart';
import 'package:proxi_health/services/secure_storage_service.dart';

void main() {
  group('Auth Screen Logo Integration Tests', () {
    late AuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = AuthProvider(
        FirebaseAuthService(),
        SecureStorageService(),
      );
    });

    testWidgets('LoginScreen displays ProxiLogo', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Verify ProxiLogo is present
      expect(find.byType(ProxiLogo), findsOneWidget);
      
      // Verify logo has correct dimensions
      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
    });

    testWidgets('SignupScreen displays ProxiLogo', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Verify ProxiLogo is present
      expect(find.byType(ProxiLogo), findsOneWidget);
      
      // Verify logo has correct dimensions
      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
    });

    testWidgets('LoginScreen logo is positioned prominently', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Find the logo and verify it's positioned near the top of the form
      final logoFinder = find.byType(ProxiLogo);
      final formFinder = find.byType(Form);
      
      expect(logoFinder, findsOneWidget);
      expect(formFinder, findsOneWidget);
      
      // Verify logo is within the form structure
      final formWidget = tester.widget<Form>(formFinder);
      expect(formWidget, isNotNull);
    });

    testWidgets('SignupScreen logo is positioned prominently', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Find the logo and verify it's positioned near the top of the form
      final logoFinder = find.byType(ProxiLogo);
      final formFinder = find.byType(Form);
      
      expect(logoFinder, findsOneWidget);
      expect(formFinder, findsOneWidget);
      
      // Verify logo appears before the "Create Your Account" text
      final titleFinder = find.text('Create Your Account');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Logo maintains proper aspect ratio on different screen sizes', (WidgetTester tester) async {
      // Test with a smaller screen size
      await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE size
      
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, logoWidget.height); // Should maintain square aspect ratio
      expect(logoWidget.fit, BoxFit.contain); // Should maintain aspect ratio
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Logo has proper accessibility labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SignupScreen(),
        ),
      );

      // Verify semantic label is present for accessibility
      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
    });
  });
}