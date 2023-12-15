import 'package:get/get.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';


class CompletedTaskController extends GetxController {
  final RxBool _getCompletedTaskInProgress = false.obs;
  TaskListModel _taskListModel = TaskListModel();

  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress.value;
  TaskListModel get getTaskListModel => _taskListModel;

  void setCompleteTaskInProgress(bool value) {
    _getCompletedTaskInProgress.value = value;
    update();
  }

  Future<void> getCompleteTask() async {
    setCompleteTaskInProgress(true);
     update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCompletedTask);

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    setCompleteTaskInProgress(false);
    update();
  }
}

