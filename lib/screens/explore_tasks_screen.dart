import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'project_detail_screen.dart';

class ExploreTasksScreen extends StatefulWidget {
  const ExploreTasksScreen({Key? key}) : super(key: key);

  @override
  State<ExploreTasksScreen> createState() => _ExploreTasksScreenState();
}

class _ExploreTasksScreenState extends State<ExploreTasksScreen> {
  static const _monthAbbrev = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];

  late List<int> monthDays;
  late int selectedDayIndex;
  late PageController _pageController;
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    monthDays = List.generate(lastDay, (i) => i + 1);
    selectedDayIndex = now.day - 1;
    _pageController = PageController(
      initialPage: selectedDayIndex,
      viewportFraction: 0.16,
    );
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasks');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() {
        _tasks
          ..clear()
          ..addAll(list.map((e) => Task.fromJson(e)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'tasks',
      jsonEncode(_tasks.map((t) => t.toJson()).toList()),
    );
  }

  double get dailyPercent {
    final daily = _tasks.where((t) => t.type == 'Daily').toList();
    if (daily.isEmpty) return 0.0;
    final isToday = DateTime.now().day - 1 == selectedDayIndex;
    final sum = daily.fold<double>(
      0.0,
      (acc, t) => acc + (isToday ? t.progress : 0.0),
    );
    return sum / daily.length;
  }

  double get projectPercent {
    final projs = _tasks.where((t) => t.type == 'Project').toList();
    if (projs.isEmpty) return 0.0;
    final sum = projs.fold<double>(0.0, (acc, t) => acc + t.progress);
    return sum / projs.length;
  }

  Future<void> _openAddTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (newTask != null) {
      setState(() => _tasks.insert(0, newTask));
      _saveTasks();
    }
  }

  Future<void> _openProjectDetail(int idx) async {
    final updated = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: _tasks[idx]),
      ),
    );
    if (updated != null) {
      final avg = updated.subtasks.isEmpty
          ? 0.0
          : updated.subtasks.map((s) => s.progress).reduce((a, b) => a + b) / updated.subtasks.length;
      final status = avg == 1.0
          ? 'Complete'
          : avg == 0.0
              ? 'Incomplete'
              : 'In Progress';
      setState(() {
        _tasks[idx] = updated.copyWith(progress: avg, status: status);
      });
      _saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthLabel = _monthAbbrev[now.month - 1];
    final selDay = monthDays[selectedDayIndex];
    final visible = _tasks.where((t) {
      final cd = DateTime(t.createdDate.year, t.createdDate.month, t.createdDate.day);
      final selDate = DateTime(now.year, now.month, selDay);
      return !cd.isAfter(selDate);
    }).toList();
    final dailyList = visible.where((t) => t.type == 'Daily').toList();
    final projectList = visible.where((t) => t.type == 'Project').toList();
    final isTodaySel = now.day - 1 == selectedDayIndex;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/cr7.jpg'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Welcome Jimx!', style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Explore Tasks', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.notifications, color: Colors.white),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 6,
                        percent: dailyPercent,
                        center: Text('${(dailyPercent * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.white12,
                      ),
                      const SizedBox(height: 4),
                      const Text('Daily', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 6,
                        percent: projectPercent,
                        center: Text('${(projectPercent * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        progressColor: Colors.redAccent,
                        backgroundColor: Colors.white12,
                      ),
                      const SizedBox(height: 4),
                      const Text('Project', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
                    child: Text('$monthLabel $selDay', style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 90,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: monthDays.length,
                  onPageChanged: (i) => setState(() => selectedDayIndex = i),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    final isSel = i == selectedDayIndex;
                    final size = isSel ? 115.0 : 85.0;
                    final color = isSel ? const Color(0xFFFFDAC1) : Colors.white12;
                    final weekday = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][DateTime(now.year, now.month, monthDays[i]).weekday - 1];
                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: size,
                        height: size,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(monthDays[i].toString(), style: TextStyle(color: isSel ? Colors.black : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(weekday, style: TextStyle(color: isSel ? Colors.black : Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your programs', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: _openAddTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Add new program'),
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    const Text('Daily', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.white30),
                    ...dailyList.map((orig) {
                      final disp = (orig.type == 'Daily' && !isTodaySel) ? orig.copyWith(progress: 0.0, status: 'Incomplete') : orig;
                      return Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TaskCard(
                            task: disp,
                            onTap: () {
                              if (orig.type == 'Project') {
                                _openProjectDetail(_tasks.indexOf(orig));
                              } else if (isTodaySel) {
                                final newProg = orig.progress < 1.0 ? 1.0 : 0.0;
                                final newSt = newProg == 1.0 ? 'Complete' : 'Incomplete';
                                setState(() {
                                  final i = _tasks.indexOf(orig);
                                  _tasks[i] = orig.copyWith(progress: newProg, status: newSt);
                                });
                                _saveTasks();
                              }
                            },
                            onDelete: () {
                              setState(() => _tasks.remove(orig));
                              _saveTasks();
                            },
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 12),
                    const Text('Projects', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.white30),
                    ...projectList.map((orig) {
                      final disp = (orig.type == 'Daily' && !isTodaySel) ? orig.copyWith(progress: 0.0, status: 'Incomplete') : orig;
                      return Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TaskCard(
                            task: disp,
                            onTap: () {
                              if (orig.type == 'Project') {
                                _openProjectDetail(_tasks.indexOf(orig));
                              } else if (isTodaySel) {
                                final newProg = orig.progress < 1.0 ? 1.0 : 0.0;
                                final newSt = newProg == 1.0 ? 'Complete' : 'Incomplete';
                                setState(() {
                                  final i = _tasks.indexOf(orig);
                                  _tasks[i] = orig.copyWith(progress: newProg, status: newSt);
                                });
                                _saveTasks();
                              }
                            },
                            onDelete: () {
                              setState(() => _tasks.remove(orig));
                              _saveTasks();
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
