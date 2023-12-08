import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';
import '../../data/model/task_count__summary_list_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';

class CancelTasksScreen extends StatefulWidget {
  const CancelTasksScreen({super.key});

  @override
  State<CancelTasksScreen> createState() => _CancelTasksScreenState();
}

class _CancelTasksScreenState extends State<CancelTasksScreen> {
  bool _getCancelledTaskInProgress = false;
  TaskCountSummaryListModel taksCountSummaryListModel =
  TaskCountSummaryListModel();
  TaskListModel taskListModel = TaskListModel();

  Future<void> getCancelledTask() async {
    _getCancelledTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCancelledTask);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    _getCancelledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState()
  {
    super.initState();
    getCancelledTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
                child: Visibility(
                  visible: _getCancelledTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: getCancelledTask,
                    child: ListView.builder(
                        itemCount: taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskListModel.taskList![index],
                            onStatusChane: (){
                              getCancelledTask();
                            },
                            showProgress: (inProgress)
                            {
                              _getCancelledTaskInProgress = inProgress;
                              if(mounted)
                              {
                                setState(() {

                                });
                              }
                            },
                          );
                        }),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}