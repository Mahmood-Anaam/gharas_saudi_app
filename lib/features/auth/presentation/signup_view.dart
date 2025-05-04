import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/widgets/footer.dart';
import 'package:gharas_saudi_app/core/widgets/header.dart';
import 'widgets/signup_body.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Header(title: "Let's", subtitle: "Create Your Account"),

          // Signup Body
          Expanded(child: SignupBody()),

          // Footer
          const Footer(),
        ],
      ),
    );
  }
}
