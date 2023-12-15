import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';

class SignUpController extends GetxController {
  bool _signUpInProgress = false;
  String _failedMessage = '';

  bool get signUpInProgress => _signUpInProgress;
  String get failedMessage => _failedMessage;

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) async {
    _signUpInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller().postRequest(
      Urls.registration,
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "mobile": mobile,
      },
    );

    _signUpInProgress = false;
    update();

    if (response.isSuccess) {
      Get.snackbar(
        'Success!',
        'Account has been created. Please log in!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
      _failedMessage = 'Account creation failed! Please try again';
    }
    return false;
  }


}
