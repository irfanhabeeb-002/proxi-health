import 'package:vide/widget_prototype.dart';
import 'package:template_project/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:vide/features/canvas/widgets/mobile_scroll_behavior.dart';

class _AppLogoWrapper extends StatelessWidget {
  const _AppLogoWrapper();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      height: 667,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MobileScrollBehavior(),
        home: const Material(
          color: Colors.transparent,
          child: Center(child: AppLogo()),
        ),
      ),
    );
  }
}

WidgetPrototypeCollection getPrototypes() {
  return WidgetPrototypeCollection(
    prototypes: {
      'default': WidgetPrototype(
        builder: (context) => const _AppLogoWrapper(),
        description: 'Default AppLogo',
      ),
    },
  );
}