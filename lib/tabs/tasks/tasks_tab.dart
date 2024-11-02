import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'task_item.dart';

class TasksTab extends StatefulWidget{
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTask = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    if(shouldGetTask){
      tasksProvider.getTasks();
      shouldGetTask = false;
    }

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.15,
              width: double.infinity,
              color: AppTheme.primary,
            ),
            PositionedDirectional(
              start: 20,
              child: SafeArea(
                child: Text(
                    'ToDo List',
                  style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppTheme.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(Duration(days: 365),),
                onDateChange: (selectedDate){
                  tasksProvider.changeSelectedDate(selectedDate);
                  tasksProvider.getTasks();
                },
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    dayNumStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    dayStrStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
              itemCount: tasksProvider.tasks.length,)
        ),
      ],
    );
  }
}