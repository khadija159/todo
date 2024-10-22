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
}