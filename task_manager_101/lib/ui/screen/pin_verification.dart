
import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';

import 'package:task_manager_101/ui/screen/reset_screen.dart';

import 'package:task_manager_101/ui/widget/body_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';
import '../widget/snack_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.eamilId});
  final String eamilId;
  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  bool _loginProgress = false;
  String enteredPin = '';

  @override
  Widget build(BuildContext context) {
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
                  child: Visibility(
                    visible: _loginProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: (){
                        pinVerification(widget.eamilId,enteredPin);
                      },
                      child: const Text('Verify'),
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
      )),
    );
  }

  Future<void> pinVerification(String email , String otpCode) async {
    setState(() {
      _loginProgress = true; // Start the progress indicator
    });

    NetworkResponse response = await NetworkCaller().getRequest(
      Urls.pinVerification(widget.eamilId, enteredPin),
    );

    // Update state and UI after network call
    setState(() {
      _loginProgress = false; // Stop the progress indicator
    });

    if (response.isSuccess) {
 if(mounted)
   {
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) =>   ResetPasswordScreen(emailId: email, otp: otpCode,),
       ),
     );
   }
    } else {
      if (response.statusCode == 401) {
      if(mounted)  showSnackBarMessage(context, "Enter Six Digit Pin");
      } else {
        if(mounted) showSnackBarMessage(context, "Email or Pin is wrong");
      }
    }
  }
}
