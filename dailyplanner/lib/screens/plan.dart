// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:dailyplanner/screens/addTask.dart';
import 'package:dailyplanner/utils/database-helper.dart';
import 'package:dailyplanner/utils/datetime-manager.dart';
import 'package:dailyplanner/utils/notification-manager.dart';
import 'package:dailyplanner/utils/utils.dart';
import 'package:dailyplanner/widgets/custom-checkbox.dart';
import 'package:dailyplanner/widgets/custom-date.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<bool> checkedStatus = [];
  List<dynamic> todayTasks = [];
  String date = "";
  String day = "";
  bool pageLoading = true;
  int daysToAdd = 0;
  DateTime focusDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  refreshPage() {
    refreshDate();
    initDB();
    initDate();
  }

  initDB() async {
    setState(() {
      pageLoading = true;
      checkedStatus = [];
    });

    // init db
    await DatabaseHelper.instance.initDB();

    // get tasks
    String formattedDate = DateFormat('yyyy-MM-dd').format(focusDate);
    todayTasks = await DatabaseHelper.instance.getAllTasks(formattedDate);

    // keep trace of the check statuses
    for (var row in todayTasks) {
      checkedStatus.add(row["checked"] == 1);
    }

    setState(() {
      pageLoading = false;
    });
  }

  refreshDate() {
    if (daysToAdd == 0) {
      setState(() {
        focusDate = DateTime.now();
      });
    } else {
      setState(() {
        focusDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      });
    }
  }

  initDate() {
    setState(() {
      if (ui.window.locale.languageCode != "it") {
        String app = "th";

        if (focusDate.day.toString() == "1" || focusDate.day.toString() == "21" || focusDate.day.toString() == "31") {
          app = "st";
        }

        if (focusDate.day.toString() == "2" || focusDate.day.toString() == "22") {
          app = "nd";
        }

        if (focusDate.day.toString() == "3" || focusDate.day.toString() == "23") {
          app = "rd";
        }

        date = Utils().getMonth(context, focusDate.month) + " " + focusDate.day.toString() + app;
      } else {
        date = focusDate.day.toString() + " " + Utils().getMonth(context, focusDate.month);
      }
      day = Utils().getWeekday(context, focusDate.weekday);
    });
  }

  @override
  void didChangeDependencies() {
    refreshPage();
    super.didChangeDependencies();
  }

  _deletePopup(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('task_deletion_title').tr(),
          content: Text('task_deletion_text').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('No');
              },
              child: Text('generic_no').tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Yes');
              },
              child: Text('generic_yes').tr(),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value == 'Yes') {
        await DatabaseHelper.instance.deleteTask(id);
        await NotificationManager().cancelNotification(id);
        refreshPage();
      } else if (value == 'No') {}
    });
  }

  _addTask() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => AddTask(daysToAdd: daysToAdd),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    ).then((value) => refreshPage());
  }

  List<Widget> _getTasks() {
    List<Widget> tasks = [];

    for (int i = 0; i < todayTasks.length; i++) {
      tasks.add(GestureDetector(
          onTap: () async {
            setState(() {
              checkedStatus[i] = !checkedStatus[i];
            });

            await DatabaseHelper.instance.checkTask(todayTasks[i]["id"], checkedStatus[i] ? 1 : 0);

            if (checkedStatus[i]) {
              await NotificationManager().cancelNotification(todayTasks[i]["id"]);
            } else {
              DateTimeManager dtm = DateTimeManager();
              dtm.split(todayTasks[i]["date"], todayTasks[i]["time"]);
              Utils().setScheduledNotification(context, todayTasks[i]["id"], todayTasks[i]["task"], dtm.year, dtm.month, dtm.day, dtm.hour, dtm.minutes);
            }
          },
          onLongPress: () {
            _deletePopup(todayTasks[i]["id"]);
          },
          child: CustomCheckBox(
            time: todayTasks[i]["time"],
            task: todayTasks[i]["task"],
            cheked: checkedStatus[i],
          )));
    }

    if (tasks.isEmpty) {
      tasks = [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: ElevatedButton(
              onPressed: () => _addTask(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                child: Text(
                  "add_task",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ).tr(),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        )
      ];
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshPage();
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            setState(() {
              daysToAdd = 1;
            });

            refreshPage();
          } else {
            setState(() {
              daysToAdd = 0;
            });

            refreshPage();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addTask(),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                    // header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        daysToAdd == 1
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    daysToAdd = 0;
                                  });

                                  refreshPage();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 35,
                                ),
                              )
                            : SizedBox(),
                        daysToAdd == 0
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    daysToAdd = 1;
                                  });

                                  refreshPage();
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 35,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),

                    // date
                    CustomDate(date: date, day: day),

                    // tasks
                    pageLoading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )))
                        : Column(
                            children: _getTasks(),
                          ),

                    SizedBox(height: 85)
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
