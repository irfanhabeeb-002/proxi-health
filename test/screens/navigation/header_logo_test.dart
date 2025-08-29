import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/screens/user/user_dashboard_screen.dart';
import 'package:proxi_health/screens/doctor/doctor_dashboard_screen.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/services/firebase_auth_service.dart';
import 'package:proxi_health/services/secure_storage_service.dart';

void main() {
  group('Header Logo Integration Tests', () {
    late AuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = AuthProvider(
        FirebaseAuthService(),
        SecureStorageService(),
      );
    });

    testWidgets('UserDashboardScreen displays logo in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Verify ProxiLogo is present in the AppBar
      expect(find.byType(ProxiLogo), findsOneWidget);
      
      // Verify it's the small variant
      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0); // LogoConfig.smallSize
      expect(logoWidget.height, 32.0);
    });

    testWidgets('DoctorDashboardScreen displays logo in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const DoctorDashboardScreen(),
          ),
        ),
      );

      // Verify ProxiLogo is present in the AppBar
      expect(find.byType(ProxiLogo), findsOneWidget);
      
      // Verify it's the small variant
      final logoWidget = tester.widget<ProxiLogo>(find.byType(ProxiLogo));
      expect(logoWidget.width, 32.0); // LogoConfig.smallSize
      expect(logoWidget.height, 32.0);
    });

    testWidgets('Logo in AppBar maintains proper spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Find the Row widget in the AppBar title
      final rowFinder = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsOneWidget);

      // Verify the Row contains both logo and text
      final rowWidget = tester.widget<Row>(rowFinder);
      expect(rowWidget.children.length, 3); // Logo, SizedBox, Text
      
      // Verify SizedBox spacing
      final sizedBoxWidget = rowWidget.children[1] as SizedBox;
      expect(sizedBoxWidget.width, 12.0);
    });

    testWidgets('Logo scales appropriately on different screen sizes', (WidgetTester tester) async {
      // Test with tablet size
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
      expect(logoWidget.width, 32.0); // Should remain consistent
      expect(logoWidget.height, 32.0);
      expect(logoWidget.fit, BoxFit.contain); // Should maintain aspect ratio
      
      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Logo visibility in AppBar across different themes', (WidgetTester tester) async {
      // Test with dark theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Verify logo is still visible
      expect(find.byType(ProxiLogo), findsOneWidget);
      
      // Test with light theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Verify logo is still visible
      expect(find.byType(ProxiLogo), findsOneWidget);
    });

    testWidgets('Logo positioning in AppBar title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Find the AppBar
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      // Verify logo is positioned at the start of the title
      final appBarWidget = tester.widget<AppBar>(appBarFinder);
      final titleWidget = appBarWidget.title as Row;
      expect(titleWidget.children.first, isA<ProxiLogo>());
    });

    testWidgets('Logo accessibility in navigation headers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthProvider>(
            create: (_) => mockAuthProvider,
            child: const UserDashboardScreen(),
          ),
        ),
      );

      // Verify semantic label is present for accessibility
      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
    });
  });
}