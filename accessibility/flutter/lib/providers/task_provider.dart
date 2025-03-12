import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  Task? _selectedTask;
  TaskStatus? _filterStatus;
  String _filterAssignee = '';
  
  // Getters
  List<Task> get tasks => _tasks;
  Task? get selectedTask => _selectedTask;
  TaskStatus? get filterStatus => _filterStatus;
  String get filterAssignee => _filterAssignee;
  
  // Tâches filtrées
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      if (_filterStatus != null && task.status != _filterStatus) {
        return false;
      }
      if (_filterAssignee.isNotEmpty && task.assignee != _filterAssignee) {
        return false;
      }
      return true;
    }).toList();
  }
  
  // Tâches groupées par statut
  Map<TaskStatus, List<Task>> get tasksByStatus {
    final result = {
      TaskStatus.todo: <Task>[],
      TaskStatus.inProgress: <Task>[],
      TaskStatus.done: <Task>[],
    };
    
    for (final task in filteredTasks) {
      result[task.status]!.add(task);
    }
    
    return result;
  }
  
  // Liste des assignés uniques
  List<String> get assignees {
    final result = _tasks
        .map((task) => task.assignee)
        .where((assignee) => assignee.isNotEmpty)
        .toSet()
        .toList();
    return result;
  }
  
  // Sélectionner une tâche
  void selectTask(Task? task) {
    _selectedTask = task;
    notifyListeners();
  }
  
  // Filtrer par statut
  void filterByStatus(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }
  
  // Filtrer par assigné
  void filterByAssignee(String assignee) {
    _filterAssignee = assignee;
    notifyListeners();
  }
  
  // Ajouter une tâche
  void addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required String assignee,
    required DateTime dueDate,
  }) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      status: status,
      assignee: assignee,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    
    _tasks.add(newTask);
    notifyListeners();
    _saveTasks();
  }
  
  // Mettre à jour une tâche
  void updateTask(String id, {
    String? title,
    String? description,
    TaskStatus? status,
    String? assignee,
    DateTime? dueDate,
  }) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: title,
        description: description,
        status: status,
        assignee: assignee,
        dueDate: dueDate,
      );
      
      // Mettre à jour la tâche sélectionnée si nécessaire
      if (_selectedTask?.id == id) {
        _selectedTask = _tasks[index];
      }
      
      notifyListeners();
      _saveTasks();
    }
  }
  
  // Supprimer une tâche
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    
    // Désélectionner la tâche si nécessaire
    if (_selectedTask?.id == id) {
      _selectedTask = null;
    }
    
    notifyListeners();
    _saveTasks();
  }
  
  // Charger les tâches depuis le stockage local
  Future<void> loadTasks(SharedPreferences prefs) async {
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksJson);
      _tasks = decodedTasks
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();
      notifyListeners();
    }
  }
  
  // Sauvegarder les tâches dans le stockage local
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(_tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }
}

