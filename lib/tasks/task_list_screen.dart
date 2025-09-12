import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Add new task input
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          labelText: "New Task",
                          prefixIcon: Icon(Icons.task, color: Colors.blue),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Colors.lightBlue, size: 30),
                      onPressed: () async {
                        final text = _taskController.text.trim();
                        if (text.isNotEmpty) {
                          await taskService.addTask(text);
                          _taskController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Task list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taskService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No tasks yet",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;

                    final title = data['title'] ?? '';
                    final isDone = data['isDone'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          isDone
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isDone ? Colors.green : Colors.deepPurple,
                          size: 28,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          isDone ? "Completed" : "Pending",
                          style: TextStyle(
                            color: isDone ? Colors.green : Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Switch(
                              value: isDone,
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.deepPurple,
                              onChanged: (val) {
                                taskService.toggleTask(id, isDone);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                taskService.deleteTask(id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
