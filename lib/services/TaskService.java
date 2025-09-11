import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _db.collection("tasks");

  /// Stream all tasks for current logged-in user
  Stream<QuerySnapshot<Map<String, dynamic>>> tasksStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _tasks
        .where("ownerId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// Add a new task
  Future<void> addTask(String title, String description) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    await _tasks.add({
      "title": title,
      "description": description,
      "completed": false,
      "ownerId": uid,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Update task status or fields
  Future<void> updateTask(String id, {String? title, String? description, bool? completed}) async {
    final data = <String, dynamic>{
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (title != null) data["title"] = title;
    if (description != null) data["description"] = description;
    if (completed != null) data["completed"] = completed;

    await _tasks.doc(id).update(data);
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }
}
