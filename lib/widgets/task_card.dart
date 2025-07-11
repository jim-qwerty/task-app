// lib/widgets/task_card.dart

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // calcular porcentaje
    final percent = task.type == 'Project'
        ? (task.subtasks.isEmpty
            ? 0.0
            : task.subtasks.map((s) => s.progress).reduce((a, b) => a + b) /
                task.subtasks.length)
        : task.progress;

    // elegir color según tipo
    final progressColor = task.type == 'Project'
        ? Colors.redAccent
        : Theme.of(context).primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 24,
              lineWidth: 4,
              percent: percent,
              center: Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              progressColor: progressColor,
              backgroundColor: Colors.white12,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${task.status}, ${task.date}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
