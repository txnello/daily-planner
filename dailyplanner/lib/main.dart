import 'package:dailyplanner/screens/plan.dart';
import 'package:dailyplanner/utils/notification-manager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();
  NotificationManager().initNotification();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('it')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Daily Planner',
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: "Poppins"),
      home: const Plan(),
    );
  }
}
