import 'package:dailyplanner/screens/plan.dart';
import 'package:dailyplanner/utils/notification-manager.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: "Poppins"),
      home: const Plan(),
    );
  }
}
