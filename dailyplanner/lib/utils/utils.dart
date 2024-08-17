// ignore_for_file: prefer_const_constructors

import 'package:dailyplanner/utils/notification-manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:easy_localization/easy_localization.dart';

class Utils {

  // set when to show a notification
  setScheduledNotification(BuildContext context, int id, String task, int year, int month, int day, int hour, int minutes) async {
    // get local timezone
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));

    // set scheduled date and time
    tz.TZDateTime? scheduledDate = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minutes,
      0,
    );

    DateTime selectedDt = DateTime(year, month, day, hour, minutes);

    // check if it is a valid date and time
    if (selectedDt.isBefore(DateTime.now())) {
      return;
    }

    String stringMinutes = minutes.toString();
    if (minutes < 10) stringMinutes = "0" + stringMinutes;

    // schedule notification
    NotificationManager().showNotification(scheduledDate, id: id, title: hour.toString() + ':' + stringMinutes, body: task);
  }

  // given month number get month name translated
  String getMonth(BuildContext context, int monthNumber) {
    String month = "";

    switch (monthNumber) {
      case 1:
        month = context.tr('generic_january');
        break;
      case 2:
        month = context.tr('generic_february');
        break;
      case 3:
        month = context.tr('generic_march');
        break;
      case 4:
        month = context.tr('generic_april');
        break;
      case 5:
        month = context.tr('generic_may');
        break;
      case 6:
        month = context.tr('generic_june');
        break;
      case 7:
        month = context.tr('generic_july');
        break;
      case 8:
        month = context.tr('generic_august');
        break;
      case 9:
        month = context.tr('generic_september');
        break;
      case 10:
        month = context.tr('generic_october');
        break;
      case 11:
        month = context.tr('generic_november');
        break;
      case 12:
        month = context.tr('generic_december');
        break;
    }

    return month;
  }


  // given week day number get week day name translated
  String getWeekday(BuildContext context, int weekday) {
    String day = "";

    switch (weekday) {
      case 1:
        day = context.tr('generic_monday');
        break;
      case 2:
        day = context.tr('generic_tuesday');
        break;
      case 3:
        day = context.tr('generic_wednesday');
        break;
      case 4:
        day = context.tr('generic_thursday');
        break;
      case 5:
        day = context.tr('generic_friday');
        break;
      case 6:
        day = context.tr('generic_saturday');
        break;
      case 7:
        day = context.tr('generic_sunday');
        break;
    }

    return day;
  }
}
