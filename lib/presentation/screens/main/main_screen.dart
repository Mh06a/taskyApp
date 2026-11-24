import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/app/app_navigator.dart';
import 'package:tasky/presentation/controllers/main_controller.dart';
import 'package:tasky/presentation/screens/home/home_screen.dart';
import 'package:tasky/presentation/screens/main/navigation_item.dart';
import 'package:tasky/presentation/screens/profile/profile_screen.dart';
import 'package:tasky/presentation/screens/tasks/tasks_screen.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
    final controller = context.watch<MainController>();
    final currentIndex = controller.currentIndex;

    void openTasksTab() => controller.setIndex(1);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(onSeeAllHighPriority: openTasksTab),
          const TasksScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: currentIndex == 2 ? null : FloatingActionButton(
        onPressed: () => AppNavigator.openTaskForm(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: controller.setIndex,
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
