import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/features/auth/services/firebase_auth_service.dart';
import 'package:go_router/go_router.dart';
import 'widgets/splash_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final flag = await FirebaseAuthService().isSignedIn();
      if (flag) {
        if (mounted) {
          context.pushReplacementNamed(AppRoute.locationPicker.name);
        }
      } else {
        if (mounted) {
          context.pushReplacementNamed(AppRoute.login.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: SplashBody()));
  }
}
