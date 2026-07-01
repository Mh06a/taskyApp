import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_project/features/tasks/completed_screen.dart';
import 'package:second_project/features/home/home_screen.dart';
import 'package:second_project/features/profile/profile_screen.dart';
import 'package:second_project/features/tasks/todo_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // here I will Create vars to class :
  int _currentIndex = 0;
  final List<Widget> _screen = [
    HomeScreen(),
    TodoScreen(),
    CompletedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/icons/home_icon.svg", 0),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/icons/toDo_icon.svg", 1),
            label: "To Do",
          ),

          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/icons/completed_icon.svg", 2),
            label: "Completed",
          ),

          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/icons/profile_icon.svg", 3),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(child: _screen[_currentIndex]),
    );
  }

  // here I will Create function to SVG Picture :
  SvgPicture _buildSvgPicture(String path, int currentIndex) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
        _currentIndex == currentIndex
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        BlendMode.srcIn,
      ),
    );
  }
}
