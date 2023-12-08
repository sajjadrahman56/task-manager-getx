import 'package:flutter/material.dart';
import 'package:task_manager_101/ui/screen/cancel_task_screen.dart';
import 'package:task_manager_101/ui/screen/completed_task_screen.dart';
import 'package:task_manager_101/ui/screen/new_task_screen.dart';
import 'package:task_manager_101/ui/screen/progress_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screen = [
    const NewTasksScreen(),
    const ProgressTasksScreen(),
    const CompletedTasksScreen(),
    const CancelTasksScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'InProgress'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel), label: 'Cancelled'),
        ],
      ),
    );
  }
}
