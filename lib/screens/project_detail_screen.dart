import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Task project;
  const ProjectDetailScreen({Key? key, required this.project})
      : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late List<Task> _subtasks;
  final _subCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clone initial subtasks
    _subtasks = List<Task>.from(widget.project.subtasks);
  }

  @override
  void dispose() {
    _subCtrl.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks.insert(
        0,
        Task(
          title: text,
          category: widget.project.category,
          status: 'Incomplete',
          date: widget.project.date,
          progress: 0.0,
          type: 'Daily',
          subtasks: const [],
          createdDate: widget.project.createdDate,
        ),
      );
      _subCtrl.clear();
    });
  }

  void _saveAndExit() {
    // Return project with modified subtasks
    Navigator.pop(
      context,
      widget.project.copyWith(subtasks: _subtasks),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: _saveAndExit,
            child: const Text('Done',
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Field for new subtask
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subCtrl,
                    decoration: const InputDecoration(
                      hintText: 'New Subtask',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32),
                  color: Theme.of(context).primaryColor,
                  onPressed: _addSubtask,
                )
              ],
            ),
            const SizedBox(height: 16),
            // Subtasks list
            Expanded(
              child: ListView.separated(
                itemCount: _subtasks.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final sub = _subtasks[i];
                  return Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TaskCard(
                        task: sub,
                        // Tapping the card toggles complete/incomplete
                        onTap: () {
                          setState(() {
                            final isComplete = sub.progress == 1.0;
                            _subtasks[i] = sub.copyWith(
                              progress: isComplete ? 0.0 : 1.0,
                              status: isComplete ? 'Incomplete' : 'Complete',
                            );
                          });
                        },
                        // Delete icon removes the subtask
                        onDelete: () {
                          setState(() {
                            _subtasks.removeAt(i);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
