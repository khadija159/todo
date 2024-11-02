import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task);

  TaskModel task;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Slidable(
        startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_){
                  FirebaseFunctions.deleteTaskFromFirestore(task.id).timeout(
                    Duration(microseconds: 100),
                    onTimeout:() {
                      Provider.of<TasksProvider>(context, listen: false).getTasks();
                      },
                  ).catchError(
                      (_) {
                        Fluttertoast.showToast(
                          msg: 'Something Went Wrong',
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIosWeb: 5,
                          backgroundColor: AppTheme.red,
                        );
                      },
                  );
                },
                backgroundColor: AppTheme.red,
                foregroundColor: AppTheme.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                margin: EdgeInsetsDirectional.only(end: 12),
                color: AppTheme.primary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      task.title,
                      style: textTheme.titleMedium?.copyWith(color: AppTheme.primary),
                  ),
                  SizedBox(height: 4,),
                  Text(
                      task.description,
                    style: textTheme.bodySmall,
                  )
                ],
              ),
              Spacer(),
              Container(
                height: 34,
                width: 69,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.check,
                  color: AppTheme.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}