import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/data/model/task_count__summary_list_model.dart';
import 'package:task_manager_101/data/model/task_list_model.dart';
import 'package:task_manager_101/ui/controller/new_task_controller.dart';
import 'package:task_manager_101/ui/screen/add_new_task.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';

import '../../data/model/task_count.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool _getNewTaskInProgress = false;
  bool _taskSummaryCountInProgress = false;

  TaskCountSummaryListModel taskCountSummaryListModel =
      TaskCountSummaryListModel();

  Future<void> getTaskCountSummaryList() async {
    _taskSummaryCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getStatusCount);

    if (response.isSuccess) {
      taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }
    _taskSummaryCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Get.find<NewTaskController>().getNewTask();
    getTaskCountSummaryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()  async {
          final response = Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddNewTask(),));
          if (response != null && response == true) {
            getTaskCountSummaryList();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        children: [
          const ProfileSummaryCard(),
          Visibility(
              visible: _taskSummaryCountInProgress == false &&
                  (taskCountSummaryListModel.taskCountList?.isNotEmpty ??
                      false),
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        taskCountSummaryListModel.taskCountList?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount =
                          taskCountSummaryListModel.taskCountList![index];
                      return FittedBox(
                        child: SummaryCard(
                          count: taskCount.sum.toString(),
                          title: taskCount.sId ?? '',
                        ),
                      );
                    }),
              )),
          Expanded(
            child: GetBuilder<NewTaskController>(
              builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.getNewTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh:( ) async {
                      getTaskCountSummaryList();
                      newTaskController.getNewTask();
                    },
                    child: ListView.builder(
                        itemCount: newTaskController.getTaskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: newTaskController.getTaskListModel.taskList![index],
                            onStatusChane: (){
                              newTaskController.getNewTask();
                            },
                            showProgress: (inProgress) {
                              newTaskController.setNewTaskInProgress(inProgress);
                            },
                          );
                        }),
                  ),
                );
              }
            ),
          )
        ],
      ),),
    );
  }
}
