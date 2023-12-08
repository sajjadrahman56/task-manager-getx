import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/task_item_card.dart';
import '../../data/model/task_count__summary_list_model.dart';
import '../../data/model/task_list_model.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/utils.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  bool _getCompletedTaskInProgress = false;
  TaskCountSummaryListModel taksCountSummaryListModel =
  TaskCountSummaryListModel();
  TaskListModel taskListModel = TaskListModel();


  Future<void> getCompleteTask() async {
    _getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCompletedTask);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    _getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState()
  {
    super.initState();
    getCompleteTask();
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
                  visible: _getCompletedTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: getCompleteTask,
                    child: ListView.builder(
                        itemCount: taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskListModel.taskList![index],
                            onStatusChane: (){
                              getCompleteTask();
                            },
                            showProgress: (inProgress)
                            {
                              _getCompletedTaskInProgress = inProgress;
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