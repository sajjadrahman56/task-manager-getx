import 'package:flutter/material.dart';
import 'package:task_manager_101/data/network_caller/network_response.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';

import 'package:task_manager_101/ui/widget/body_background.dart';
import 'package:task_manager_101/ui/widget/snack_message.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/utility/regex.dart';
import '../../data/utility/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signUpInProgress = false;
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
                    'Join with us',
                    style: Theme.of(context).textTheme.titleLarge,
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
                        return 'Please enter your email';
                      }
                      RegExp regex =   RegExp(ReGex.emailPattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'Enter valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter your first name';
                      }
                      RegExp regex =   RegExp( ReGex.namePattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'First name must not contain numbers';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter your last name';
                      }
                      RegExp regex =  RegExp( ReGex.namePattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'Last name must not contain numbers';
                      } else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter your phone number';
                      }

                      RegExp regex = RegExp(ReGex.phonePattern.toString());
                      if (!regex.hasMatch(value!)) {
                        return 'Enter a valid BD phone number';
                      } else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'enter your Password  ';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _signUpInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _signUP();
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
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

  Future<void> _signUP() async {
    if (_formKey.currentState!.validate()) {
      _signUpInProgress = true;
      if (mounted) setState(() {});

      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.registration, body: {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
        "mobile": _mobileController.text.trim(),
      });
      _signUpInProgress = false;
      if (mounted) setState(() {});

      if (response.isSuccess) {
        _clearTextField();
        if (mounted) {
          showSnackBarMessage(
              context, 'Account Has been Created . Please Log in !');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()));
        } else {
          if (mounted) {
            showSnackBarMessage(
                context, 'Account creation failed ! Please try again', true);
          }
        }
      }
    }
  }

  void _clearTextField() {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
