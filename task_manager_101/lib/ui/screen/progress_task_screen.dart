import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';
import '../../data/model/task_count__summary_list_model.dart';
import '../controller/progress_task_controller.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({super.key});
  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {
  TaskCountSummaryListModel taksCountSummaryListModel =
  TaskCountSummaryListModel();

  @override
  void initState()
  {
    super.initState();
    Get.find<ProgressTaskController>().getProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<ProgressTaskController>(
                builder: (progressTaskController) {
                  return Visibility(
                    visible: progressTaskController.getProgressTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh:( ) async {
                        progressTaskController.getProgressTask();
                      },
                      child: ListView.builder(
                          itemCount: progressTaskController.getTaskListModel.taskList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskItemCard(
                              task: progressTaskController.getTaskListModel.taskList![index],
                              onStatusChane: (){
                                progressTaskController.getProgressTask();
                              },
                                showProgress: (inProgress) {
                                  progressTaskController.setProgressTaskInProgress(inProgress);
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
