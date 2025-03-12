import 'package:flutter/material.dart';

enum TaskStatus { todo, inProgress, done }

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.todo:
        return 'À faire';
      case TaskStatus.inProgress:
        return 'En cours';
      case TaskStatus.done:
        return 'Terminé';
    }
  }

  Color getColor(BuildContext context) {
    switch (this) {
      case TaskStatus.todo:
        return Colors.amber;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.green;
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final String assignee;
  final DateTime dueDate;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignee,
    required this.dueDate,
    required this.createdAt,
  });

  // Convertir Task en Map pour le stockage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'assignee': assignee,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer Task à partir d'un Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values[json['status']],
      assignee: json['assignee'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Créer une copie de Task avec des modifications
  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    String? assignee,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignee: assignee ?? this.assignee,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }
}
