import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final CollectionReference tasks =
  FirebaseFirestore.instance.collection('tasks');

  // Add a new task
  Future<void> addTask(String title) async {
    try {
      await tasks.add({
        'title': title,
        'isDone': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // Stream of tasks
  Stream<QuerySnapshot> getTasks() {
    return tasks.orderBy('createdAt', descending: true).snapshots();
  }

  // Toggle task done/undone
  Future<void> toggleTask(String id, bool isDone) async {
    await tasks.doc(id).update({'isDone': !isDone});
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }
}
