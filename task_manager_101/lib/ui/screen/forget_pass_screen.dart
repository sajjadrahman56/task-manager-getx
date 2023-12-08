import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';
import 'package:task_manager_101/ui/screen/pin_verification.dart';
import 'package:task_manager_101/ui/widget/body_background.dart';

import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';
import '../widget/snack_message.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _looginProgress = false;
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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'A 6 digit otp will sent to your email check the mail box twice !',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter valid Email';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _looginProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          pinSend(_emailController.text.toString());
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an account ?"),
                      TextButton(
                          // here task assign
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
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

  Future<void> pinSend(String email) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _looginProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.forgetPass(_emailController.text.toString()));

    _looginProgress = false;
    if (mounted) {
      setState(() {});
    }
    log(response.toString());

    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PinVerificationScreen(eamilId: email)));
      }
    } else {
      if (response.statusCode == 401) {
        if (mounted) {
          showSnackBarMessage(context, "Please check email");
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, "Email not Found");
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
