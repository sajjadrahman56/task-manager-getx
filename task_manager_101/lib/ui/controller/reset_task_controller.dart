import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';
import '../widget/snack_message.dart';


class ResetPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool loginProgress = false.obs;

  Future<void> resetPass(String emailId, String otp, BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    loginProgress.value = true;
    update();
    Map<String, dynamic> resetPasswordBody = {
      "email": emailId,
      "OTP": otp,
      "password": passwordController.text,
    };

    NetworkResponse response = await NetworkCaller().resetPasswordRequest(
      Urls.recoverPass,
      body: resetPasswordBody,
    );

    loginProgress.value = false;
    update();

    if (response.isSuccess) {
      Get.offAll(const LoginScreen());
      // Optionally, show a success message
    } else {
      if (response.statusCode == 401) {
        showSnackBarMessage(Get.context!, "Please check email/OTP");
      } else {
        showSnackBarMessage(Get.context!, "Password reset failed. Please try again.");
      }
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}


