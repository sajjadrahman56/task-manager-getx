import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_101/ui/controller/auth_controller.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';

import '../screen/edit_profile_screen.dart';
class ProfileSummaryCard extends StatefulWidget {
  const ProfileSummaryCard({
    super.key,this.enableOnTap=true
  });

  final bool enableOnTap ;

  @override
  State<ProfileSummaryCard> createState() => _ProfileSummaryCardState();
}

class _ProfileSummaryCardState extends State<ProfileSummaryCard> {
  @override
  Widget build(BuildContext context) {

    return   GetBuilder<AuthController>(
      builder: (authController) {
        Uint8List imageBytes = const  Base64Decoder().convert(authController.user?.photo ?? ' ');
        return ListTile(
          onTap: (){
           if(widget.enableOnTap)
           {
             Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()));
           }
          },
          leading:   CircleAvatar(
            child: authController.user?.photo == null ? const Icon(Icons.person) : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child:Image.memory(imageBytes,
                fit: BoxFit.cover,
                )),

          ),
          title: Text(
            fullName(authController),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            authController.user?.email??" ",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            onPressed: () async {
             await  AuthController.claerSaveCheceData().then((_) {
               Get.offAll(const LoginScreen());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),

          tileColor: Colors.green[700],
        );
      }
    );
  }

  String   fullName( AuthController authController){
    return "${authController.user?.firstName ?? 'default'} "
        " ${authController.user?.lastName?? 'Name'}";
  }
}