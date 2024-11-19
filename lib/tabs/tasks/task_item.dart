import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

import '../auth/user_provider.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task, {super.key});

  TaskModel task;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Slidable(
        startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_){
                  String userId = Provider.of<UserProvider>(context, listen: false).currentUser!.id;
                  FirebaseFunctions.deleteTaskFromFirestore(task.id, userId).then(
                    (_) {
                      Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
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
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.only(end: 12),
                color: AppTheme.primary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      task.title,
                      style: textTheme.titleMedium?.copyWith(color: AppTheme.primary),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                      task.description,
                    style: textTheme.bodySmall,
                  )
                ],
              ),
              const Spacer(),
              Container(
                height: 34,
                width: 69,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
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