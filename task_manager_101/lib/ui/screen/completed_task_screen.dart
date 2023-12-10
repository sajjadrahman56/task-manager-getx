import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';
import '../../data/model/task_count__summary_list_model.dart';
import '../../data/model/task_list_model.dart';
import '../controller/completed_task_controller.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});
  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  TaskCountSummaryListModel taskCountSummaryListModel =
  TaskCountSummaryListModel();

  @override
  void initState()
  {
    super.initState();
    Get.find<CompletedTaskController>().getCompleteTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
                child: GetBuilder<CompletedTaskController>(
                  builder: (completedTaskController) {
                    return Visibility(
                      visible: completedTaskController.getCompletedTaskInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: RefreshIndicator(
                        onRefresh: completedTaskController.getCompleteTask,
                        child: ListView.builder(
                            itemCount: completedTaskController.getTaskListModel.taskList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return TaskItemCard(
                                task: completedTaskController.getTaskListModel.taskList![index],
                                onStatusChane: (){
                                  completedTaskController.getCompleteTask();
                                },
                                showProgress: (inProgress)
                                {
                                  completedTaskController.setCompleteTaskInProgress(inProgress);
                                },
                              );
                            }),
                      ),
                    );
                  }
                )
            )
          ],
        ),
      ),
    );
  }
}