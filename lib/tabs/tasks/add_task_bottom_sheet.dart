import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/default_text_form_field.dart';
import 'package:todo/default_elevated_button.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth/user_provider.dart';

class AddTaskBottomSheet extends StatefulWidget{
  const AddTaskBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet>{
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd,MM,yyyy');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme
        .of(context)
        .textTheme
        .titleMedium;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(15),
            right: Radius.circular(15),
          ),
        ),
        height: MediaQuery
            .sizeOf(context)
            .height * 0.5,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Add new task',
                style: titleMediumStyle,
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: titleController,
                hintText: 'Enter task title',
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'Title can not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: descriptionController,
                hintText: 'Enter task description',
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'Description can not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              Text(
                'Select date',
                style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8,),
              InkWell(
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  if (dateTime != null && dateTime != selectedDate) {
                    selectedDate = dateTime;
                    setState(() {});
                  }
                },
                child: Text(dateFormat.format(selectedDate)),
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                  label: 'Add',
                  onPressed: () {
                    if(formKey.currentState!.validate()){
                      addTask();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
  void addTask(){
    TaskModel task = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate);
    String userId = Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    FirebaseFunctions.addTaskToFirestore(task, userId).then(
      (_){
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg: 'Task Added Successfully',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
        );
      },
    )
        .catchError(
            (error)
        {
          Fluttertoast.showToast(
              msg: 'Something Went Wrong',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.red,
          );
      }
    );
  }
}