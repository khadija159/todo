import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/user_model.dart';
import 'models/task_model.dart';

class FirebaseFunctions{
  static CollectionReference<TaskModel> getTaskCollection(String userId) =>
      getUserCollection()
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
        fromFirestore: (docSnapshot, options) =>
            TaskModel.fromJson(docSnapshot.data()!),
        toFirestore: (taskModel, _) => taskModel.toJson(),
      );

  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
        fromFirestore: (docSnapshot, options) =>
            UserModel.fromJson(docSnapshot.data()!),
        toFirestore: (UserModel, _) => UserModel.toJson(),
      );

  static Future<void> addTaskToFirestore(TaskModel task, String userId){
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    DocumentReference<TaskModel> doc = taskCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await taskCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(String taskId, String userId) async {
    CollectionReference<TaskModel> taskCollection = getTaskCollection(userId);
    return taskCollection.doc(taskId).delete();
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password})async {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password);
    UserModel user = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email
    );
    CollectionReference<UserModel> userCollection = getUserCollection();
    await userCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
}) async {
    UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
    CollectionReference<UserModel> userCollection = getUserCollection();
    DocumentSnapshot<UserModel> docSnapshot =
      await userCollection.doc(credential.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();
}