import 'package:flutter/material.dart';

class AppCustomButton extends StatelessWidget {
  final List<Widget> children;
  VoidCallback onPressed;
  bool outlineEnabled;

  AppCustomButton(
      {super.key,
      required this.children,
      this.outlineEnabled = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: outlineEnabled
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              elevation:
                  outlineEnabled ? const WidgetStatePropertyAll(0) : null,
              overlayColor: outlineEnabled
                  ? WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary.withOpacity(0.04))
                  : null,
              iconColor: outlineEnabled
                  ? WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary)
                  : null,
              foregroundColor: outlineEnabled
                  ? WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary)
                  : null,
              backgroundColor: outlineEnabled
                  ? const WidgetStatePropertyAll(Colors.transparent)
                  : null),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center, children: children)),
    );
  }
}
