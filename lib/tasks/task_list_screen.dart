/*

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({super.key});

  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
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
                      icon: const Icon(Icons.add_circle, color: Colors.lightBlue, size: 30),
                      onPressed: () {
                        if (_taskController.text.trim().isNotEmpty) {
                          taskService.addTask(_taskController.text.trim());
                          _taskController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

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

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final doc = tasks[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;

                    final title = data['title'] ?? '';
                    final isDone = data['isDone'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: isDone,
                          activeColor: Colors.lightBlue,
                          onChanged: (_) {
                            taskService.toggleTask(id, isDone);
                          },
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            taskService.deleteTask(id);
                          },
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
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({super.key});

  final TextEditingController _taskController = TextEditingController();

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
          onPressed: () {
            Navigator.pop(context); // 👈 Goes back to login screen
          },
        ),
      ),
      body: Column(
        children: [
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
                      onPressed: () {
                        if (_taskController.text.trim().isNotEmpty) {
                          taskService.addTask(_taskController.text.trim());
                          _taskController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

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

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final doc = tasks[index];
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
                        leading: Checkbox(
                          value: isDone,
                          activeColor: Colors.lightBlue,
                          onChanged: (_) {
                            taskService.toggleTask(id, isDone);
                          },
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone ? Colors.grey : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon:
                          const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            taskService.deleteTask(id);
                          },
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
