import 'package:get/get.dart';

import '../../data/model/task_count__summary_list_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/utils.dart';


class NewTaskController extends GetxController{
  RxBool _getNewTaskInProgress =  false.obs;

  TaskListModel _taskListModel = TaskListModel();

  bool get getNewTaskInProgress => _getNewTaskInProgress.value;
  TaskListModel get getTaskListModel => _taskListModel;

  void setNewTaskInProgress(bool value) {
    _getNewTaskInProgress.value = value;
    update();
  }

  Future<bool> getNewTask() async {

    bool isSuccess = false;
    setNewTaskInProgress(true);
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getNewTask);

    setNewTaskInProgress(false);

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    return isSuccess;
  }
}