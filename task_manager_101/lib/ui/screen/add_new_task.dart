import 'package:flutter/material.dart';
import 'package:task_manager_101/data/network_caller/network_response.dart';
import 'package:task_manager_101/data/network_caller/network_caller.dart';
import 'package:task_manager_101/ui/widget/body_background.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/snack_message.dart';

import '../../data/utility/utils.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _createTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const ProfileSummaryCard(),
          Expanded(
              child: BodyBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Task',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          controller: _subjectTEController,
                          decoration: const InputDecoration(hintText: 'subject name'),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Enter Your Subject';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          controller: _descriptionTEController,
                          maxLines: 5,
                          decoration: const InputDecoration(hintText: 'Description'),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return 'Enter Your description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: _createTaskInProgress == false,
                            replacement: const Center(child: CircularProgressIndicator(),),
                            child: ElevatedButton(
                                onPressed: _createTask,
                                child: const Icon(Icons.arrow_circle_right_outlined)),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ))
        ]),
      ),
    );
  }

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      _createTaskInProgress = true;
      if (mounted) {
        setState(() {});
      }
        final NetworkResponse response = await NetworkCaller().postRequest(Urls.createNewTask,
        body:{
            "title": _subjectTEController.text.trim(),
            "description": _descriptionTEController.text.trim(),
            "status":"New"
        });
      _createTaskInProgress = false;
      if (mounted) {
        setState(() {});
      }

      if(response.isSuccess){
        _subjectTEController.clear();
        _descriptionTEController.clear();
        if(mounted){
          showSnackBarMessage(context, 'create new task ');
        }
      }
    }else{
       if(mounted){
         showSnackBarMessage(context, 'create new task failed , try again',true);
       }
      }
  }

  @override
  void dispose() {
    _descriptionTEController.dispose();
    _subjectTEController.dispose();
    super.dispose();
  }
}
