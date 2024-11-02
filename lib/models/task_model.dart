import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
});

  TaskModel.fromJson(Map<String, dynamic> json) : this(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    date: (json['date'] as Timestamp).toDate() ,
    isDone: json['isDone'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': Timestamp.fromDate(date),
    'isDone': isDone,
  };
}

