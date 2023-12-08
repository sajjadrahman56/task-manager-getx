import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';

import '../../data/model/task_count__summary_list_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({super.key});

  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {

  bool _getProgressTaskInProgress = false;
  TaskCountSummaryListModel taksCountSummaryListModel =
  TaskCountSummaryListModel();
  TaskListModel taskListModel = TaskListModel();


  Future<void> getProgressTask() async {
    _getProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getProgressTask);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    _getProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState()
  {
    super.initState();
    getProgressTask();
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
                visible: _getProgressTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getProgressTask,
                  child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: taskListModel.taskList![index],
                          onStatusChane: (){
                            getProgressTask();
                          },
                          showProgress: (inProgress)
                          {
                            _getProgressTaskInProgress = inProgress;
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
