import 'package:flutter/material.dart';
import '../utils/logo_assets.dart';

/// A reusable widget that displays the Proxi Health logo
/// 
/// This widget provides consistent logo display across the application
/// with configurable sizing and styling options.
class ProxiLogo extends StatelessWidget {
  /// Width of the logo. If null, uses intrinsic width
  final double? width;
  
  /// Height of the logo. If null, uses intrinsic height
  final double? height;
  
  /// How the logo should be inscribed into the available space
  final BoxFit fit;
  
  /// Color filter to apply to the logo (for tinted versions)
  final Color? color;
  
  /// Semantic label for accessibility
  final String? semanticLabel;

  const ProxiLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  });

  /// Creates a small-sized logo (32px)
  const ProxiLogo.small({
    super.key,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  }) : width = LogoConfig.smallSize,
       height = LogoConfig.smallSize;

  /// Creates a medium-sized logo (64px)
  const ProxiLogo.medium({
    super.key,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  }) : width = LogoConfig.mediumSize,
       height = LogoConfig.mediumSize;

  /// Creates a large-sized logo (128px)
  const ProxiLogo.large({
    super.key,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  }) : width = LogoConfig.largeSize,
       height = LogoConfig.largeSize;

  /// Creates a splash screen-sized logo (200px)
  const ProxiLogo.splash({
    super.key,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  }) : width = LogoConfig.splashSize,
       height = LogoConfig.splashSize;

  @override
  Widget build(BuildContext context) {
    Widget logoImage = Image.asset(
      LogoAssets.primaryLogo,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel ?? 'Proxi Health Logo',
      errorBuilder: (context, error, stackTrace) {
        // Fallback widget if logo asset fails to load
        return Container(
          width: width ?? 64,
          height: height ?? 64,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.health_and_safety,
            size: (width ?? 64) * 0.6,
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );

    // Apply color filter if specified
    if (color != null) {
      logoImage = ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: logoImage,
      );
    }

    return logoImage;
  }
}