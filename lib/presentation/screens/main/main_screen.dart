import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/screens/home/home_screen.dart';
import 'package:tasky/presentation/screens/main/navigation_item.dart';
import 'package:tasky/presentation/screens/profile/profile_screen.dart';
import 'package:tasky/presentation/screens/tasks/tasks_screen.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _openTasksTab() => _onItemSelected(1);

  static const _navigationItems = [
    NavigationItem(
      label: 'Home',
      iconPath: AppAssets.homeIcon,
    ),
    NavigationItem(
      label: 'Tasks',
      iconPath: AppAssets.tasksIcon,
    ),
    NavigationItem(
      label: 'Profile',
      iconPath: AppAssets.profileIcon,
    ),
  ];

  void _onItemSelected(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  BottomNavigationBarItem _buildItem(
      String label,
      String iconPath,
      ) {
    return BottomNavigationBarItem(
      label: label,
      icon: Builder(
        builder: (context) {
          final iconTheme = IconTheme.of(context);

          return AppSvgIcon(
            assetPath: iconPath,
            size: iconTheme.size ?? AppSizes.icon24,
            color: iconTheme.color,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onSeeAllHighPriority: _openTasksTab),
          const TasksScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: _currentIndex == 2 ? null : FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.taskForm),
        tooltip: 'Add task',
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemSelected,
        items: _navigationItems
            .map(
              (item) => _buildItem(
            item.label,
            item.iconPath,
          ),
        )
            .toList(),
      ),
    );
  }
}
