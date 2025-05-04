import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/navigation/router/routes.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'package:gharas_saudi_app/core/widgets/custom_button.dart';
import 'package:gharas_saudi_app/core/widgets/custom_text_field.dart';
import 'package:gharas_saudi_app/features/auth/services/firebase_auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuthService().signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          context.pushReplacementNamed(AppRoute.locationPicker.name);
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
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
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
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: SizeConfig.defaultSize!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(
                          AppRoute.resetPassword.name,
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: SizeConfig.defaultSize! * 1.8,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize!),

                CustomButton(
                  onPressed: _login,
                  text: 'Login',
                  isLoading: _isLoading,
                ),

                SizedBox(height: SizeConfig.defaultSize! * 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: SizeConfig.defaultSize! * 1.5),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(AppRoute.signup.name);
                      },
                      child: Text(
                        "Sign Up",
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
