import 'package:vide/widget_prototype.dart';
import 'package:template_project/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:vide/features/canvas/widgets/mobile_scroll_behavior.dart';

class _PrimaryButtonWrapper extends StatelessWidget {
  final bool isLoading;
  const _PrimaryButtonWrapper({this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      height: 667,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MobileScrollBehavior(),
        home: Material(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: 'Sign In',
                onPressed: () {},
                isLoading: isLoading,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

WidgetPrototypeCollection getPrototypes() {
  return WidgetPrototypeCollection(
    prototypes: {
      'default': WidgetPrototype(
        builder: (context) => const _PrimaryButtonWrapper(),
        description: 'Default PrimaryButton',
      ),
      'loading': WidgetPrototype(
        builder: (context) => const _PrimaryButtonWrapper(isLoading: true),
        description: 'Loading state',
      ),
    },
  );
}