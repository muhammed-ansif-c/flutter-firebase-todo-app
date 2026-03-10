import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app_herody/domain/models/task_model.dart';

class TaskService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

    Future<void> addTask(TaskModel task) async {
    final uid = userId;
    if (uid == null) return;

    await _db
        .child("tasks")
        .child(uid)
        .child(task.id)
        .set(task.toJson());
  }

    Future<List<TaskModel>> fetchTasks() async {
    final uid = userId;
    if (uid == null) return [];

    final snapshot = await _db.child("tasks").child(uid).get();

    if (!snapshot.exists) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.values
        .map((task) => TaskModel.fromJson(Map<String, dynamic>.from(task)))
        .toList();
  }

    Future<void> updateTask(TaskModel task) async {
    final uid = userId;
    if (uid == null) return;

    await _db
        .child("tasks")
        .child(uid)
        .child(task.id)
        .update(task.toJson());
  }

    Future<void> deleteTask(String taskId) async {
    final uid = userId;
    if (uid == null) return;

    await _db.child("tasks").child(uid).child(taskId).remove();
  }
}