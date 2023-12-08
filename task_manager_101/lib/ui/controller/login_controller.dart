
import 'package:get/get.dart';

import '../../data/model/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';
import 'auth_controller.dart';

class LogInController extends GetxController{
  bool _loginProgress = false;
  String _failedMessage = '';

  bool get LogInProgress => _loginProgress;
  String get FailedMessage => _failedMessage;

  Future<bool> login(String email , String password) async {

    _loginProgress = true;
     update();

    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {
          "email": email,
          "password": password
        },
        isLogIn: true);

    _loginProgress = false;
    update();

    if (response.isSuccess) {
      await Get.find<AuthController>().saveUserInformation(response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));

      return true;
    } else {
      if (response.statusCode == 401) {


          _failedMessage= "Please check email/password";

      } else {

          _failedMessage="Log in failed , Try again";

      }
    }
    return false;
  }
}