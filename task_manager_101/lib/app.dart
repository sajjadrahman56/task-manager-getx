import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/screen/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
