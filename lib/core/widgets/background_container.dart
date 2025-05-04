import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget? child;
  final Alignment alignment;

  const BackgroundContainer({
    super.key,
    this.child,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(255, 133, 151, 134),
            Color.fromARGB(255, 171, 203, 180),
          ],
        ),
      ),
      child: child,
    );
  }
}
