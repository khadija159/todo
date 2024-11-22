import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

import '../../app_theme.dart';
import '../../default_elevated_button.dart';
import '../../default_text_form_field.dart';
import '../../models/task_model.dart';
import '../auth/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class updateTask extends StatefulWidget{
  static const String routeName = '/update';

  const updateTask({super.key});
  @override
  State<StatefulWidget> createState() => _updateTaskState();

}

class _updateTaskState extends State<updateTask>{
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd,MM,yyyy');
  TaskModel? selectedTask;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    String userId = Provider.of<UserProvider>(context, listen: false).currentUser!.id;
    //final tasksProvider = Provider.of<TasksProvider>(context);

    if(selectedTask == null){
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
      selectedTask = tasksProvider.selectedTask;
      titleController.text = selectedTask!.title;
      descriptionController.text = selectedTask!.description;
      selectedDate = selectedTask!.date;
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Column(
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
                      AppLocalizations.of(context)!.todoList,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppTheme.white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,right: 20,top: 90),
                  decoration: const BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(15),
                      right: Radius.circular(15),
                    ),
                  ),
                  height: MediaQuery
                      .sizeOf(context)
                      .height * 0.8,
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Task',
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
                            label: 'Save Changes',
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                if(selectedDate!=null){
                                  selectedTask?.title = titleController.text;
                                  selectedTask?.description = descriptionController.text;
                                  selectedTask?.date = selectedDate;
                                }
                                FirebaseFunctions.updateTaskInFirestore(selectedTask!, userId).then(
                                      (_){
                                    Navigator.of(context).pop();
                                    Provider.of<TasksProvider>(context,listen: false).getTasks(userId);
                                    Fluttertoast.showToast(
                                      msg: 'Task Updated Successfully',
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
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
