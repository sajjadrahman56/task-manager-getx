import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';
import '../screen/reset_screen.dart';
import '../widget/snack_message.dart';

class PinVerificationController extends GetxController {
  RxBool loginProgress = false.obs;

  Future<void> pinVerification(String email, String otpCode) async {
    loginProgress.value = true; // Start the progress indicator
    update();
    NetworkResponse response = await NetworkCaller().getRequest(
      Urls.pinVerification(email, otpCode),
    );

    loginProgress.value = false; // Stop the progress indicator
    update();

    if (response.isSuccess)   {
      if (response.statusCode == 200) {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordScreen(emailId: email, otp: otpCode),
          ),
        );
        update();
      } else {
        if (response.statusCode == 401) {
           showSnackBarMessage(Get.context!,"Enter Six Digit Pin");
          update();
        } else {
          showSnackBarMessage(Get.context!,"Email or Pin is wrong");
          update();
        }
      }
    } else {
       showSnackBarMessage(Get.context!,"Pin is wrong, Double Check", true);
      update();
    }
  }
}
