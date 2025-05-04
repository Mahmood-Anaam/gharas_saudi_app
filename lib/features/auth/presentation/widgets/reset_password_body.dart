import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:gharas_saudi_app/core/widgets/custom_text_field.dart';
import 'package:gharas_saudi_app/features/auth/services/firebase_auth_service.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({super.key});

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuthService().resetPassword(_emailController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: SizeConfig.screenWidth! * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.defaultSize! * 1.5),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: SizeConfig.defaultSize! * 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 1.5),

                    Text(
                      'Enter the email address associated with your account and we will send you a link to reset your password.',

                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.defaultSize! * 1.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize! * 1.5),

                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: SizeConfig.defaultSize! * 1.5),

                CustomButton(
                  onPressed: _resetPassword,
                  text: 'Reset Password',
                  isLoading: _isLoading,
                ),

                SizedBox(height: SizeConfig.defaultSize! * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(AppRoute.login.name);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: SizeConfig.defaultSize! * 1.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
