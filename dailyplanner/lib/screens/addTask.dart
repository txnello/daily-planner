// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures, use_build_context_synchronously, sized_box_for_whitespace

import 'package:dailyplanner/utils/database-helper.dart';
import 'package:flutter/material.dart';
import 'package:dailyplanner/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class AddTask extends StatefulWidget {
  final int daysToAdd;
  const AddTask({super.key, this.daysToAdd = 0});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isFocused = false;
  bool loadingSave = false;

  final TextEditingController taskController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // set correct date
    if (widget.daysToAdd == 0) {
      setState(() {
        selectedDate = DateTime.now();
      });
    } else {
      setState(() {
        selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      });
    }

    // check if task field has focus
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  String formatDate(String inputDateStr) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd");
    DateFormat outputFormat = DateFormat("dd/MM/yyyy");
    DateTime inputDate = inputFormat.parse(inputDateStr);
    String outputDateStr = outputFormat.format(inputDate);

    return outputDateStr;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
      });
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final time = DateTime(today.year, today.month, today.day, timeOfDay.hour, timeOfDay.minute);

    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
      });
  }

  _saveTask() async {
    setState(() {
      loadingSave = true;
    });

    String date = selectedDate.toLocal().toString().split(' ')[0];
    String time = formatTimeOfDay(selectedTime);

    int id = await DatabaseHelper.instance.insertTask(taskController.text, date, time);
    Navigator.pop(context);

    Utils().setScheduledNotification(context, id, taskController.text, date, time);
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // header
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 35,
                      ),
                    ),
                    Text(
                      "add_task",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ).tr(),
                    SizedBox(width: 45)
                  ],
                ),

                // task
                SizedBox(height: 30),
                TextField(
                  focusNode: focusNode,
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: context.tr('generic_i_have_to'),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),

                // date
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('generic_on').toLowerCase() + ' ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      formatDate(selectedDate.toLocal().toString().split(' ')[0]),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Icon(Icons.calendar_month),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ],
                ),

                // time
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('generic_at').toLowerCase() + ' ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      selectedTime.format(context),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () => _selectTime(context),
                      child: Icon(Icons.watch_later_outlined),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Colors.black)),
                      ),
                    ),
                  ],
                ),

                // save button
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveTask(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                      child: !loadingSave
                          ? Text(
                              context.tr('generic_save').toUpperCase(),
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
