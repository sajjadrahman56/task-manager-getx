import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
    Uint8List imageBytes = const  Base64Decoder().convert(AuthController.user?.photo ?? ' ');
    return   ListTile(
      onTap: (){
       if(widget.enableOnTap)
       {
         Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditProfileScreen()));
       }
      },
      leading:   CircleAvatar(
        child: AuthController.user?.photo == null ? const Icon(Icons.person) : ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child:Image.memory(imageBytes,
            fit: BoxFit.cover,
            )),

      ),
      title: Text(
        fullName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
         AuthController.user?.email??" ",
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          AuthController.claerSaveCheceData().then((_) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            }
          });
        },
        icon: const Icon(Icons.logout_outlined),
      ),

      tileColor: Colors.green[700],
    );
  }

  String get fullName{
    return "${AuthController.user?.firstName ?? 'default'}  ${AuthController.user?.lastName?? 'Name'}";

  }
}