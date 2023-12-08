import 'package:get/get.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';


class ProgressTaskController extends GetxController {
  RxBool _getProgressTaskInProgress = false.obs;
  TaskListModel _taskListModel = TaskListModel();

  bool get getProgressTaskInProgress => _getProgressTaskInProgress.value;
  TaskListModel get getTaskListModel => _taskListModel;

  void setProgressTaskInProgress(bool value) {
    _getProgressTaskInProgress.value = value;
    update();
  }

  Future<void> getProgressTask() async {
    setProgressTaskInProgress(true);
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getProgressTask);

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    setProgressTaskInProgress(false);
  }
}

