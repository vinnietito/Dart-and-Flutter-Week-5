import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // Toggle theme mode when the icon is pressed
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(taskProvider.tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // Mark task as completed
                        taskProvider.toggleTaskCompletion(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Completed ${taskProvider.tasks.length} tasks today!'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskDialog(context, taskProvider);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog to add a new task
  void _addTaskDialog(BuildContext context, TaskProvider taskProvider) {
    TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter your task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  taskProvider.addTask(taskController.text);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
