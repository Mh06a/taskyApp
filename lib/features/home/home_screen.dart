import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/features/add_task/new_task_screen.dart';
import 'package:second_project/features/home/components/custom_achieved_tasks.dart';
import 'package:second_project/core/widgets/custom_add_buttton.dart';
import 'package:second_project/features/home/components/high_priority_tasks.dart';
import 'package:second_project/features/home/components/silver_custom_list.dart';
import 'package:second_project/features/home/home_controller.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //step1 ---- Create The page :
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()..init(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSizes.w16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // step2.2 --- Good Text :
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/Vector.svg",
                          width: AppSizes.w42,
                          height: AppSizes.h42,
                        ),
                        SizedBox(width: AppSizes.w8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<HomeController, String?>(
                              selector: (context, controller) =>
                                  controller.username,
                              builder: (context, username, child) {
                                return Text(
                                  "Good Evening ,$username",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                );
                              },
                            ),

                            Selector<HomeController, String?>(
                              selector: (context, controller) =>
                                  controller.motivationQuote,
                              builder: (context, motivationQuote, child) {
                                return Text(
                                  "$motivationQuote",
                                  style: Theme.of(context).textTheme.titleSmall,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: AppSizes.w30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          width: AppSizes.w18,
                          height: AppSizes.h18,
                          child: SvgPicture.asset(
                            "assets/icons/sun.svg",
                            width: AppSizes.w15,
                            height: AppSizes.h15,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.h16),

                    // step2.3 --- Yuhuu Text :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Yuhuu ,Your work Is",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "almost done ! ",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),

                            SvgPicture.asset(
                              "assets/icons/waving_hand.svg",
                              height: AppSizes.h32,
                              width: AppSizes.w32,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h16),

                    //step2.5 ---Achieved Tasks :
                    CustomAchievedTasks(),

                    SizedBox(height: AppSizes.h8),

                    //step2.6 ---High Priority Tasks :
                    HighPriorityTasks(),

                    Padding(
                      padding: EdgeInsets.only(
                        top: AppSizes.h24,
                        bottom: AppSizes.h16,
                      ),
                      child: Text(
                        "My Tasks",
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),

              //step2.4 --- my tasks :
              SilverCustomList(),

              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomAddButton(
                        onPressed: () async {
                          final bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AddNewTask();
                              },
                            ),
                          );
                          if (result != null && result) {
                            context.read<TasksController>().init();
                          }
                        },
                        buttonText: "Add New Task",
                        height: AppSizes.h40,
                        width: AppSizes.w167,
                        icon: Icon(Icons.add),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
