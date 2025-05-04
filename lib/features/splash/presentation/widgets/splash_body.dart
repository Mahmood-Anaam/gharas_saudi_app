import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/widgets/background_container.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundContainer(
          alignment: Alignment.topCenter,
          child: Image.asset('assets/images/2030.png'),
        ),

        Image.asset('assets/images/logo.png'),

        Positioned(
          top: -10,
          left: -20,
          child: Image.asset('assets/images/splash_left_1.png'),
        ),

        Positioned(
          bottom: -80,
          left: -20,
          child: Image.asset('assets/images/splash_left_2.png', height: 350),
        ),

        Positioned(
          top: -5,
          right: -30,
          child: Image.asset('assets/images/splash_right.png'),
        ),

        Positioned(
          bottom: -80,
          right: -20,
          child: Image.asset('assets/images/splash_right.png', height: 350),
        ),
      ],
    );
  }
}
