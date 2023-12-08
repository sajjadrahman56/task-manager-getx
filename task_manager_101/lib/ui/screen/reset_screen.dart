import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';
import 'package:task_manager_101/ui/widget/body_background.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';
import '../widget/snack_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.emailId, required this.otp});

  final String emailId, otp;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'A 6 digit otp will sent to your email check the mail box twice',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _loginProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: resetPass,
                        child: const Text("Confirm"),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future<void> resetPass() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _loginProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> resetPasswordBody = {
      "email": widget.emailId,
      "OTP": widget.otp,
      "password": _passwordController.text
    };

    NetworkResponse response = await NetworkCaller().resetPasswordRequest(
      Urls.recoverPass,
      body: resetPasswordBody,
    );

    log(response.toString());
    _loginProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context)=> const LoginScreen())
        );
      }
    } else {
      if (response.statusCode == 401) {
        if (mounted) {
          showSnackBarMessage(context, "Please check email/password");
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, "Log in failed , Try again");
        }
      }
    }
  }
  @override
  void dispose()
  {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
