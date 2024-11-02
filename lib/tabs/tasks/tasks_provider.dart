import 'package:flutter/material.dart';

import '../../firebase_functions.dart';
import '../../models/task_model.dart';

class TasksProvider with ChangeNotifier{
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasks() async {
    List<TaskModel>allTasks = await FirebaseFunctions.getAllTasksFromFirestore();
    tasks = allTasks.where((task) =>
        task.date.year == selectedDate.year &&
        task.date.month == selectedDate.month &&
        task.date.day == selectedDate.day,
    ).toList();
    notifyListeners();
  }

  void changeSelectedDate(DateTime date){
    selectedDate = date;
  }
}