// lib/models/task.dart

//import 'package:flutter/material.dart';

class Task {
  final String title;
  final String category;
  final String status;
  final String date;
  final double progress;
  final String type;
  final List<Task> subtasks;
  final DateTime createdDate;

  const Task({
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.progress,
    this.type = 'Diario',
    this.subtasks = const [],
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'status': status,
        'date': date,
        'progress': progress,
        'type': type,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'createdDate': createdDate.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> j) => Task(
        title: j['title'] as String,
        category: j['category'] as String,
        status: j['status'] as String,
        date: j['date'] as String,
        progress: (j['progress'] as num).toDouble(),
        type: j['type'] as String,
        subtasks: (j['subtasks'] as List)
            .map((e) => Task.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdDate: DateTime.parse(j['createdDate'] as String),
      );

  Task copyWith({
    String? title,
    String? category,
    String? status,
    String? date,
    double? progress,
    String? type,
    List<Task>? subtasks,
    DateTime? createdDate,
  }) {
    return Task(
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      date: date ?? this.date,
      progress: progress ?? this.progress,
      type: type ?? this.type,
      subtasks: subtasks ?? this.subtasks,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
