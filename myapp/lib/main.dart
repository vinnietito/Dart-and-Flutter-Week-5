import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  // Store the current theme mode
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Method to toggle theme mode
  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners to rebuild with the new theme
  }
}

class TaskProvider with ChangeNotifier {
  List<String> _tasks = [];

  List<String> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  // Method to load tasks from shared_preferences
  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      _tasks = savedTasks;
      notifyListeners();
    }
  }

  // Method to add task
  void addTask(String task) async {
    _tasks.add(task);
    notifyListeners();
    _saveTasks();
  }

  // Method to remove task
  void removeTask(int index) async {
    _tasks.removeAt(index);
    notifyListeners();
    _saveTasks();
  }

  // Method to toggle task completion
  void toggleTaskCompletion(int index) {
    _tasks[index] = _tasks[index] + ' - Completed';
    notifyListeners();
    _saveTasks();
  }

  // Method to save tasks to shared_preferences
  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode, // Set the themeMode based on the provider
      home: const TaskPage(),
    );
  }
}
