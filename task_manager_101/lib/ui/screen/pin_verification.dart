
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';
import 'package:task_manager_101/ui/widget/body_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controller/context_controller.dart';
import '../controller/pin_verification_controller.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.emailId});
  final String emailId;
  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String enteredPin = '';
  @override
  void initState()
  {
    super.initState();
   /// Get.find<PinVerificationController>().pinVerification( widget.eamilId, enteredPin);
  }
  @override
  Widget build(BuildContext context) {
    GetContext.context = context;
    return Scaffold(
      body: BodyBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Pin Verification',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
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
                    PinCodeTextField(
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        activeColor: Colors.green,
                        inactiveFillColor: Colors.white,
                      ),
                      enableActiveFill: true,
                      onCompleted: (v) {
                        setState(() {
                          enteredPin = v;
                        });
                      },
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        return true;
                      },
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<PinVerificationController>(
                        builder: (pinVerificationController) {
                          return Visibility(
                            visible:  pinVerificationController.loginProgress.value == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                pinVerificationController.pinVerification(widget.emailId, enteredPin);
                              },
                              child: const Text('Verify'),
                            ),
                          );
                        }
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
          )),
    );
  }
}