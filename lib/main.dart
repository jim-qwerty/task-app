// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/explore_tasks_screen.dart';

void main() {
  // incluso aquí si quieres trampolín:
  // BindingBase.debugZoneErrorsAreFatal = false;

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Captura errores de Flutter binding
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
    };

    runApp(const MyApp());
  }, (error, stack) {
    // Captura errores asíncronos
    debugPrint('⚠️ Zona capturó excepción: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notion v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF7D4AEA),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ExploreTasksScreen(),
    );
  }
}
