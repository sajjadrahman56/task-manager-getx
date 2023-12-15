import 'package:get/get.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';

class CancelTaskController extends GetxController {
  final RxBool _getCancelledTaskInProgress = false.obs;
  TaskListModel _taskListModel = TaskListModel();

  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress.value;
  TaskListModel get getTaskListModel => _taskListModel;

  void setCancelTaskInProgress(bool value) {
    _getCancelledTaskInProgress.value = value;
    update();
  }

  Future<void> getCancelledTask() async {
    setCancelTaskInProgress(true);
     update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCancelledTask);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    setCancelTaskInProgress(false);
    update();
  }

}

