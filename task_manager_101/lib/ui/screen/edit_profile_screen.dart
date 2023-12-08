import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_101/data/model/user_model.dart';
import 'package:task_manager_101/data/network_caller/network_response.dart';
import 'package:task_manager_101/data/network_caller/network_caller.dart';
import 'package:task_manager_101/ui/controller/auth_controller.dart';
import 'package:task_manager_101/ui/widget/profile_summary_card.dart';
import 'package:task_manager_101/ui/widget/snack_message.dart';
import '../../data/utility/utils.dart';
import '../widget/body_background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool updateProfileInProgress = false;

  XFile? photo;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.user?.email ?? " ";
    _firstNameTEController.text = AuthController.user?.firstName ?? " ";
    _lastNameTEController.text = AuthController.user?.lastName ?? " ";
    _mobileTEController.text = AuthController.user?.mobile ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(
              enableOnTap: false,
            ),
            Expanded(
                child: BodyBackground(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          imagePickerMethod(),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _emailTEController,
                            decoration: const InputDecoration(hintText: 'Email'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _firstNameTEController,
                            decoration: const InputDecoration(hintText: 'First Name'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'enter your first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _lastNameTEController,
                            decoration:const InputDecoration(hintText: 'Last Name'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'enter your last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _mobileTEController,
                            decoration: const InputDecoration(hintText: 'Mobile'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'enter valid phone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _passwordTEController,
                            decoration: const InputDecoration(
                                hintText: 'Password (optional)'),

                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: updateProfileInProgress == false,
                              replacement: const Center(child: CircularProgressIndicator()),
                              child: ElevatedButton(
                                  onPressed: updateProfile,
                                  child: const Icon(
                                      Icons.arrow_circle_right_outlined)),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    String? photoInBase64;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    updateProfileInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> inputData = {
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "email": _emailTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      inputData["password"] = _passwordTEController.text;
    }

    if(photo != null)
      {
        List<int> readImage = await photo!.readAsBytes();
         photoInBase64 = base64Encode(readImage);
        inputData['photo'] = photoInBase64;
      }

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.profileUpdate, body: inputData);

    updateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      AuthController.updateUserInformation(UserModel(email: _emailTEController.text.trim(),
      firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        photo: photoInBase64 ?? AuthController.user?.photo,
      ));
      if (mounted) {
        showSnackBarMessage(context, 'Update profile Success');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Update profile Failed, try again');
      }
    }
  }

  Container imagePickerMethod() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  )),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async{
           final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera , imageQuality: 50);

           if(image != null)
             {
              photo = image;
              if(mounted)
                {
                  setState(() {

                  });
                }
             }
            },
            child: Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: Visibility(
                  visible: photo == null,
                  replacement: Text(photo?.name ?? ' '),
                  child: const Text(' select a picture')),
            ),
          ),
        ),
      ]),
    );
  }


}
