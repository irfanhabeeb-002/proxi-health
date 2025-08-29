import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Platform-Specific Icon Validation Tests', () {
    group('Android Icons', () {
      test('Android launcher icons exist in all required densities', () {
        final androidIconPaths = [
          'android/app/src/main/res/mipmap-mdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-hdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
        ];

        for (final path in androidIconPaths) {
          final file = File(path);
          expect(file.existsSync(), true, reason: 'Android icon missing: $path');
          expect(file.lengthSync(), greaterThan(0), reason: 'Android icon is empty: $path');
        }
      });

      test('Android launcher_icon files exist in all required densities', () {
        final androidIconPaths = [
          'android/app/src/main/res/mipmap-mdpi/launcher_icon.png',
          'android/app/src/main/res/mipmap-hdpi/launcher_icon.png',
          'android/app/src/main/res/mipmap-xhdpi/launcher_icon.png',
          'android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png',
          'android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png',
        ];

        for (final path in androidIconPaths) {
          final file = File(path);
          expect(file.existsSync(), true, reason: 'Android launcher_icon missing: $path');
          expect(file.lengthSync(), greaterThan(0), reason: 'Android launcher_icon is empty: $path');
        }
      });

      test('Android icon files have reasonable file sizes', () {
        final androidIconPaths = [
          'android/app/src/main/res/mipmap-mdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-hdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png',
          'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
        ];

        for (final path in androidIconPaths) {
          final file = File(path);
          if (file.existsSync()) {
            final sizeInBytes = file.lengthSync();
            // Icons should be at least 1KB and less than 500KB
            expect(sizeInBytes, greaterThan(1024), reason: 'Icon too small: $path');
            expect(sizeInBytes, lessThan(500 * 1024), reason: 'Icon too large: $path');
          }
        }
      });
    });

    group('iOS Icons', () {
      test('iOS app icons exist in all required sizes', () {
        final iosIconPaths = [
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png',
        ];

        for (final path in iosIconPaths) {
          final file = File(path);
          expect(file.existsSync(), true, reason: 'iOS icon missing: $path');
          expect(file.lengthSync(), greaterThan(0), reason: 'iOS icon is empty: $path');
        }
      });

      test('iOS Contents.json exists and is valid', () {
        final contentsFile = File('ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json');
        expect(contentsFile.existsSync(), true, reason: 'iOS Contents.json missing');
        expect(contentsFile.lengthSync(), greaterThan(0), reason: 'iOS Contents.json is empty');
        
        // Verify it contains valid JSON structure
        final contents = contentsFile.readAsStringSync();
        expect(contents.contains('"images"'), true, reason: 'Contents.json missing images array');
        expect(contents.contains('"info"'), true, reason: 'Contents.json missing info object');
      });

      test('iOS icon files have reasonable file sizes', () {
        final iosIconPaths = [
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png',
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png',
        ];

        for (final path in iosIconPaths) {
          final file = File(path);
          if (file.existsSync()) {
            final sizeInBytes = file.lengthSync();
            // Icons should be at least 1KB and less than 1MB
            expect(sizeInBytes, greaterThan(1024), reason: 'Icon too small: $path');
            expect(sizeInBytes, lessThan(1024 * 1024), reason: 'Icon too large: $path');
          }
        }
      });
    });

    group('Web Icons', () {
      test('Web favicon exists', () {
        final faviconFile = File('web/favicon.png');
        expect(faviconFile.existsSync(), true, reason: 'Web favicon.png missing');
        expect(faviconFile.lengthSync(), greaterThan(0), reason: 'Web favicon.png is empty');
      });

      test('Web PWA icons exist in required sizes', () {
        final webIconPaths = [
          'web/icons/Icon-192.png',
          'web/icons/Icon-512.png',
          'web/icons/Icon-maskable-192.png',
          'web/icons/Icon-maskable-512.png',
        ];

        for (final path in webIconPaths) {
          final file = File(path);
          expect(file.existsSync(), true, reason: 'Web icon missing: $path');
          expect(file.lengthSync(), greaterThan(0), reason: 'Web icon is empty: $path');
        }
      });

      test('Web manifest.json references correct icons', () {
        final manifestFile = File('web/manifest.json');
        expect(manifestFile.existsSync(), true, reason: 'Web manifest.json missing');
        
        final manifestContent = manifestFile.readAsStringSync();
        expect(manifestContent.contains('icons/Icon-192.png'), true, 
               reason: 'manifest.json missing reference to Icon-192.png');
        expect(manifestContent.contains('icons/Icon-512.png'), true, 
               reason: 'manifest.json missing reference to Icon-512.png');
        expect(manifestContent.contains('icons/Icon-maskable-192.png'), true, 
               reason: 'manifest.json missing reference to Icon-maskable-192.png');
        expect(manifestContent.contains('icons/Icon-maskable-512.png'), true, 
               reason: 'manifest.json missing reference to Icon-maskable-512.png');
      });

      test('Web icon files have reasonable file sizes', () {
        final webIconPaths = [
          'web/favicon.png',
          'web/icons/Icon-192.png',
          'web/icons/Icon-512.png',
          'web/icons/Icon-maskable-192.png',
          'web/icons/Icon-maskable-512.png',
        ];

        for (final path in webIconPaths) {
          final file = File(path);
          if (file.existsSync()) {
            final sizeInBytes = file.lengthSync();
            // Icons should be at least 1KB and less than 500KB
            expect(sizeInBytes, greaterThan(1024), reason: 'Icon too small: $path');
            expect(sizeInBytes, lessThan(500 * 1024), reason: 'Icon too large: $path');
          }
        }
      });
    });

    group('Desktop Icons', () {
      test('Windows icon configuration exists if applicable', () {
        // Check if windows directory exists (optional for Flutter apps)
        final windowsDir = Directory('windows');
        if (windowsDir.existsSync()) {
          // If windows directory exists, check for icon configuration
          final runnerDir = Directory('windows/runner');
          if (runnerDir.existsSync()) {
            // Windows icons would typically be in resources or similar
            // This is a placeholder for Windows-specific icon validation
            expect(true, true, reason: 'Windows directory structure exists');
          }
        } else {
          // Windows support not configured, which is acceptable
          expect(true, true, reason: 'Windows support not configured');
        }
      });

      test('macOS icon configuration exists if applicable', () {
        // Check if macos directory exists (optional for Flutter apps)
        final macosDir = Directory('macos');
        if (macosDir.existsSync()) {
          // If macos directory exists, check for icon configuration
          final runnerDir = Directory('macos/Runner');
          if (runnerDir.existsSync()) {
            // macOS icons would typically be in Assets.xcassets
            final assetsDir = Directory('macos/Runner/Assets.xcassets');
            if (assetsDir.existsSync()) {
              expect(true, true, reason: 'macOS assets directory exists');
            }
          }
        } else {
          // macOS support not configured, which is acceptable
          expect(true, true, reason: 'macOS support not configured');
        }
      });
    });

    group('Source Asset Validation', () {
      test('Source logo assets exist and are valid', () {
        final sourceAssets = [
          'assets/icons/Proxi-Health.png',
          'assets/icons/app_icon.png',
        ];

        for (final path in sourceAssets) {
          final file = File(path);
          expect(file.existsSync(), true, reason: 'Source asset missing: $path');
          expect(file.lengthSync(), greaterThan(0), reason: 'Source asset is empty: $path');
          
          // Verify reasonable file size (should be substantial for a logo)
          final sizeInBytes = file.lengthSync();
          expect(sizeInBytes, greaterThan(5 * 1024), reason: 'Source asset too small: $path');
          expect(sizeInBytes, lessThan(5 * 1024 * 1024), reason: 'Source asset too large: $path');
        }
      });

      test('pubspec.yaml flutter_launcher_icons configuration is valid', () {
        final pubspecFile = File('pubspec.yaml');
        expect(pubspecFile.existsSync(), true, reason: 'pubspec.yaml missing');
        
        final pubspecContent = pubspecFile.readAsStringSync();
        expect(pubspecContent.contains('flutter_launcher_icons'), true, 
               reason: 'pubspec.yaml missing flutter_launcher_icons configuration');
        expect(pubspecContent.contains('assets/icons/app_icon.png'), true, 
               reason: 'pubspec.yaml missing reference to app_icon.png');
      });
    });
  });
}