import 'package:flutter/material.dart';

class ProxiLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? primaryColor;
  final Color? secondaryColor;

  const ProxiLogo({
    super.key,
    this.size = 60,
    this.showText = true,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? const Color(0xFF1E3A8A);
    final secondary = secondaryColor ?? const Color(0xFF06B6D4);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A2332),
                primary,
                secondary,
              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Heart shape made of two circles
              Positioned(
                left: size * 0.2,
                top: size * 0.25,
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: size * 0.2,
                top: size * 0.25,
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    color: secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Bottom part of heart
              Positioned(
                bottom: size * 0.2,
                child: Container(
                  width: size * 0.3,
                  height: size * 0.3,
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(size * 0.15),
                      bottomRight: Radius.circular(size * 0.15),
                    ),
                  ),
                ),
              ),
              // Plus sign overlay
              Container(
                width: size * 0.4,
                height: size * 0.4,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: size * 0.25,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.2),
          Text(
            'PROXI HEALTH',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark 
                  ? Colors.white 
                  : const Color(0xFF1E293B),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}