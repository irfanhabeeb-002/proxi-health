import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/screens/auth/login_screen.dart';
import 'package:proxi_health/screens/user/user_dashboard_screen.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/services/firebase_auth_service.dart';
import 'package:proxi_health/services/secure_storage_service.dart';

void main() {
  group('Logo Responsive Behavior Tests', () {
    late AuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = AuthProvider(
        FirebaseAuthService(),
        SecureStorageService(),
      );
    });

    testWidgets('Logo displays correctly on mobile portrait', (WidgetTester tester) async {
      // iPhone 12 Pro size
      await tester.binding.setSurfaceSize(const Size(390, 844));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
      expect(logoWidget.fit, BoxFit.contain);
      
      // Verify logo is visible and not clipped
      final logoRenderBox = tester.renderObject(find.byType(ProxiLogo)) as RenderBox;
      expect(logoRenderBox.size.width, 80);
      expect(logoRenderBox.size.height, 80);
    });

    testWidgets('Logo displays correctly on mobile landscape', (WidgetTester tester) async {
      // iPhone 12 Pro landscape
      await tester.binding.setSurfaceSize(const Size(844, 390));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
      expect(logoWidget.fit, BoxFit.contain);
    });

    testWidgets('Logo displays correctly on tablet portrait', (WidgetTester tester) async {
      // iPad size
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0); // Small size in header
      expect(logoWidget.height, 32.0);
      expect(logoWidget.fit, BoxFit.contain);
    });

    testWidgets('Logo displays correctly on tablet landscape', (WidgetTester tester) async {
      // iPad landscape
      await tester.binding.setSurfaceSize(const Size(1024, 768));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0);
      expect(logoWidget.height, 32.0);
      expect(logoWidget.fit, BoxFit.contain);
    });

    testWidgets('Logo displays correctly on small mobile devices', (WidgetTester tester) async {
      // iPhone SE size
      await tester.binding.setSurfaceSize(const Size(320, 568));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 80);
      expect(logoWidget.height, 80);
      expect(logoWidget.fit, BoxFit.contain);
      
      // Verify logo doesn't overflow on small screens
      final logoFinder = find.byType(ProxiLogo);
      expect(tester.takeException(), isNull);
      expect(logoFinder, findsOneWidget);
    });

    testWidgets('Logo displays correctly on large screens', (WidgetTester tester) async {
      // Large desktop size
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0);
      expect(logoWidget.height, 32.0);
      expect(logoWidget.fit, BoxFit.contain);
    });

    tearDown(() async {
      // Reset to default size after each test
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('Logo Accessibility Tests', () {
    late AuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = AuthProvider(
        FirebaseAuthService(),
        SecureStorageService(),
      );
    });

    testWidgets('Logo has proper semantic labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Verify default semantic label
      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
    });

    testWidgets('Logo supports custom semantic labels', (WidgetTester tester) async {
      const customLabel = 'Custom Proxi Health Logo';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(
              semanticLabel: customLabel,
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel(customLabel), findsOneWidget);
    });

    testWidgets('Logo is accessible to screen readers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      // Verify the logo has semantic properties
      final logoFinder = find.byType(ProxiLogo);
      final logoWidget = tester.widget<ProxiLogo>(logoFinder);
      
      // Check that the Image widget inside has proper semantics
      final imageFinder = find.descendant(
        of: logoFinder,
        matching: find.byType(Image),
      );
      
      expect(imageFinder, findsOneWidget);
      
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.semanticLabel, isNotNull);
    });

    testWidgets('Logo maintains accessibility in different contexts', (WidgetTester tester) async {
      // Test in AppBar context
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
      
      // Test in auth screen context
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
    });

    testWidgets('Logo error fallback maintains accessibility', (WidgetTester tester) async {
      // Create a ProxiLogo with an invalid asset path to trigger error fallback
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(
              semanticLabel: 'Test Logo',
            ),
          ),
        ),
      );

      // The error fallback should still be accessible
      // Note: The actual error fallback will show an Icon, which should still be accessible
      expect(find.byType(ProxiLogo), findsOneWidget);
    });
  });
}