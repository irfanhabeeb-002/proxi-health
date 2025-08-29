import 'package:flutter/material.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';

/// Legacy AppLogo widget - now uses ProxiLogo component
/// 
/// This widget is maintained for backward compatibility with existing code
/// but internally uses the new ProxiLogo component for consistency.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    return ProxiLogo(
      width: size,
      height: size,
    );
  }
}