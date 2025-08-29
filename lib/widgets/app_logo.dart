import 'package:flutter/material.dart';
import 'package:proxi_health/theme/colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.health_and_safety,
          size: size,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        const Text(
          'Proxi-Health',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}