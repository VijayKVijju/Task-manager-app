import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String? taskId;
  final String? existingTitle;
  final bool? existingCompleted;

  const AddEditTaskScreen({
    super.key,
    this.taskId,
    this.existingTitle,
    this.existingCompleted,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final titleCtrl = TextEditingController();
  bool completed = false;

  @override
  void initState() {
    super.initState();
    titleCtrl.text = widget.existingTitle ?? "";
    completed = widget.existingCompleted ?? false;
  }

  Future<void> saveTask() async {
    final user = FirebaseAuth.instance.currentUser!;
    final tasks = FirebaseFirestore.instance.collection("tasks");
//task details
    if (widget.taskId == null) {
      await tasks.add({
        "title": titleCtrl.text.trim(),
        "completed": completed,
        "ownerId": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } else {
      await tasks.doc(widget.taskId).update({
        "title": titleCtrl.text.trim(),
        "completed": completed,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(widget.taskId == null ? "Add Task" : "Edit Task"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: "Task Title",
                      prefixIcon: const Icon(Icons.task, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Completed"),
                      Checkbox(
                        value: completed,
                        activeColor: Colors.lightBlue,
                        onChanged: (v) => setState(() => completed = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: saveTask,
                      child: const Text("Save", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
