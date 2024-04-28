import 'package:dailyplanner/screens/plan.dart';
import 'package:dailyplanner/utils/notification-manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
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
