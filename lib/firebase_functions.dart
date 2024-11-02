import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/task_model.dart';

class FirebaseFunctions{
  static CollectionReference<TaskModel> getTaskCollection() =>
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
        fromFirestore: (docSnapshot, options) =>
            TaskModel.fromJson(docSnapshot.data()!),
        toFirestore: (taskModel, _) => taskModel.toJson(),
      );

  static Future<void> addTaskToFirestore(TaskModel task){
    CollectionReference<TaskModel> taskCollection = getTaskCollection();
    DocumentReference<TaskModel> doc = taskCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore() async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection();
    QuerySnapshot<TaskModel> querySnapshot = await taskCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(taskId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection();
    return taskCollection.doc(taskId).delete();
  }
}