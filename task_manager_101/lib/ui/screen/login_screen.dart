import 'package:flutter/material.dart';
import 'package:task_manager_101/data/model/user_model.dart';
import 'package:task_manager_101/data/network_caller/network_response.dart';
import 'package:task_manager_101/data/network_caller/network_caller.dart';
import 'package:task_manager_101/ui/controller/auth_controller.dart';
import 'package:task_manager_101/ui/screen/forget_pass_screen.dart';
import 'package:task_manager_101/ui/screen/main_buttom_nav_screen.dart';
import 'package:task_manager_101/ui/screen/sign_up_screen.dart';
import 'package:task_manager_101/ui/widget/body_background.dart';
import 'package:task_manager_101/ui/widget/snack_message.dart';
import '../../data/utility/regex.dart';
import '../../data/utility/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                    'Get Started with',
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
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _loginProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          login();
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _loginProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {
          "email": _emailController.text.trim(),
          "password": _passwordController.text
        },
        isLogIn: true);

    _loginProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      await AuthController.saveUserInformation(response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));

     if(mounted){
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => const MainBottomNavScreen()));
     }
    } else {
      if (response.statusCode == 401) {
        if (mounted) {

          showSnackBarMessage(context, "Please check email/password", true);
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, "Log in failed , Try again");
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
