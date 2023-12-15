import 'package:get/get.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';
import '../screen/pin_verification.dart';
import '../widget/snack_message.dart';

class ForgetPassController extends GetxController {
  RxBool loginProgress = false.obs;

  Future<void> pinSend(String email) async {
    loginProgress.value = true;

    NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.forgetPass(email));

    loginProgress.value = false;

    if (response.isSuccess) {
      Get.to(PinVerificationScreen(emailId: email));
    } else {
      if (response.statusCode == 401) {
        showSnackBarMessage(Get.context!, "Please check email");
      } else {
        showSnackBarMessage(Get.context!, "Email not Found");
      }
    }
  }
}
