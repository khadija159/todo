import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/default_text_form_field.dart';
import 'package:todo/default_elevated_button.dart';

class AddTaskBottomSheet extends StatefulWidget{
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

    return Container(
      height: MediaQuery
          .sizeOf(context)
          .height * 0.5,
      padding: EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Add new task',
              style: titleMediumStyle,
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
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
            SizedBox(height: 16,),
            Text(
              'Select date',
              style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8,),
            InkWell(
              onTap: () async {
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (dateTime != null && dateTime != selectedDate) {
                  selectedDate = dateTime;
                  setState(() {});
                }
              },
              child: Text(dateFormat.format(selectedDate)),
            ),
            SizedBox(height: 32),
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
    );
  }
  void addTask(){
    print('function called');
  }
}