import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'widgets/login_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Header(
            title: 'Login to your account',
            subtitle: '',
          ),

          // Signup Body
          Expanded(child: LoginBody()),

          // Footer
          const Footer(),
        ],
      ),
    );
  }
}
