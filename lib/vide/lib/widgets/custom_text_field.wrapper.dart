import 'package:vide/widget_prototype.dart';
import 'package:proxi_health/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:vide/features/canvas/widgets/mobile_scroll_behavior.dart';

class _CustomTextFieldWrapper extends StatelessWidget {
  const _CustomTextFieldWrapper();

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: TextEditingController(),
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: TextEditingController(),
                  labelText: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                ),
              ],
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
        builder: (context) => const _CustomTextFieldWrapper(),
        description: 'Default CustomTextField',
      ),
    },
  );
}