import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/controller/auth_controller.dart';
import 'package:task_manager_101/ui/controller/cancel_task_controller.dart';
import 'package:task_manager_101/ui/controller/forget_pass_controller.dart';
import 'package:task_manager_101/ui/controller/login_controller.dart';
import 'package:task_manager_101/ui/controller/pin_verification_controller.dart';
import 'package:task_manager_101/ui/controller/progress_task_controller.dart';
import 'package:task_manager_101/ui/screen/splash_screen.dart';
import 'package:get/get.dart';
import 'ui/controller/completed_task_controller.dart';
import 'ui/controller/new_task_controller.dart';
import 'ui/controller/reset_task_controller.dart';
import 'ui/controller/sign_up_controller.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigationKey,
      home: SplashScreen(),
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,      
                ),        
        )
      ,primaryColor: Colors.green,
      primarySwatch: Colors.green,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding:   EdgeInsets.symmetric( vertical: 10),  
        ),
      )
      ),
      initialBinding: ControllerBinder(),
    );
  }
}


class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(ProgressTaskController());
    Get.put(AuthController());
     Get.put(LogInController());
     Get.put(NewTaskController());
     Get.put(CompletedTaskController());
     Get.put(CancelTaskController());
     Get.put(PinVerificationController());
     Get.put(ResetPasswordController());
    Get.put(SignUpController());
    Get.put(ForgetPassController());


  }

}