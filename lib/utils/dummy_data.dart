import '../models/task.dart';

/// Sample data for the week
final List<Map<String, String>> weekDays = [
  {'day': '4', 'label': 'Sat'},
  {'day': '5', 'label': 'Sun'},
  {'day': '6', 'label': 'Mon'},
  {'day': '7', 'label': 'Tue'},
  {'day': '8', 'label': 'Wed'},
];

/// Sample tasks
final List<Task> tasks = [
  Task(
    title: 'Chat Application',
    category: 'General',
    status: 'Incomplete',
    date: 'Mar 13, 2022',
    progress: 0.0,
    type: 'Daily',
    createdDate: DateTime(2022, 3, 13),
  ),
  Task(
    title: '.NET Website',
    category: 'General',
    status: 'In Progress',
    date: 'Mar 16, 2022',
    progress: 0.5,
    type: 'Daily',
    createdDate: DateTime(2022, 3, 16),
  ),
  Task(
    title: 'NFT Website',
    category: 'General',
    status: 'Complete',
    date: 'Mar 16, 2022',
    progress: 1.0,
    type: 'Daily',
    createdDate: DateTime(2022, 3, 16),
  ),
];
