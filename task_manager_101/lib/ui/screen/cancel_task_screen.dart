import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';
import '../../data/model/task_count__summary_list_model.dart';
import '../controller/cancel_task_controller.dart';

class CancelTasksScreen extends StatefulWidget {
  const CancelTasksScreen({super.key});

  @override
  State<CancelTasksScreen> createState() => _CancelTasksScreenState();
}

class _CancelTasksScreenState extends State<CancelTasksScreen> {
  TaskCountSummaryListModel taksCountSummaryListModel =
  TaskCountSummaryListModel();
  @override
  void initState()
  {
    super.initState();
    Get.find<CancelTaskController>().getCancelledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
                child: GetBuilder<CancelTaskController>(
                  builder: (cancelTaskController) {
                    return Visibility(
                      visible: cancelTaskController.getCancelledTaskInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: RefreshIndicator(
                        onRefresh: cancelTaskController.getCancelledTask,
                        child: ListView.builder(
                            itemCount: cancelTaskController.getTaskListModel.taskList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return TaskItemCard(
                                task: cancelTaskController.getTaskListModel.taskList![index],
                                onStatusChane: (){
                                  cancelTaskController.getCancelledTask();
                                },
                                showProgress: (inProgress)
                                {
                                  cancelTaskController.setCancelTaskInProgress(inProgress);
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