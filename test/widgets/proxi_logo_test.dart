import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/utils/logo_assets.dart';

void main() {
  group('ProxiLogo Widget Tests', () {
    testWidgets('renders with default configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(),
          ),
        ),
      );

      // Verify the Image widget is present
      expect(find.byType(Image), findsOneWidget);
      
      // Verify semantic label
      expect(find.bySemanticsLabel('Proxi Health Logo'), findsOneWidget);
    });

    testWidgets('renders with custom width and height', (WidgetTester tester) async {
      const testWidth = 100.0;
      const testHeight = 80.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(
              width: testWidth,
              height: testHeight,
            ),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, testWidth);
      expect(imageWidget.height, testHeight);
    });

    testWidgets('renders small variant with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo.small(),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, LogoConfig.smallSize);
      expect(imageWidget.height, LogoConfig.smallSize);
    });

    testWidgets('renders medium variant with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo.medium(),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, LogoConfig.mediumSize);
      expect(imageWidget.height, LogoConfig.mediumSize);
    });

    testWidgets('renders large variant with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo.large(),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, LogoConfig.largeSize);
      expect(imageWidget.height, LogoConfig.largeSize);
    });

    testWidgets('renders splash variant with correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo.splash(),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, LogoConfig.splashSize);
      expect(imageWidget.height, LogoConfig.splashSize);
    });

    testWidgets('applies custom semantic label', (WidgetTester tester) async {
      const customLabel = 'Custom Logo Label';

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

    testWidgets('applies color filter when color is specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(
              color: Colors.red,
            ),
          ),
        ),
      );

      // Verify ColorFiltered widget is present when color is specified
      expect(find.byType(ColorFiltered), findsOneWidget);
    });

    testWidgets('does not apply color filter when color is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(),
          ),
        ),
      );

      // Verify ColorFiltered widget is not present when color is null
      expect(find.byType(ColorFiltered), findsNothing);
    });

    testWidgets('uses correct asset path', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, LogoAssets.primaryLogo);
    });

    testWidgets('applies correct BoxFit', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProxiLogo(
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.fit, BoxFit.cover);
    });
  });
}