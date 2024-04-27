// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures, use_build_context_synchronously, sized_box_for_whitespace

import 'package:dailyplanner/utils/database-helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  final int daysToAdd;
  const AddTask({super.key, this.daysToAdd = 0});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  bool loadingSave = false;
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.daysToAdd == 0) {
      setState(() {
        selectedDate = DateTime.now();
      });
    } else {
      setState(() {
        selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      });
    }

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

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final time = DateTime(today.year, today.month, today.day, timeOfDay.hour, timeOfDay.minute);

    // Formattare l'orario come "hh:mm"
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  _saveTask() async {
    setState(() {
      loadingSave = true;
    });

    await DatabaseHelper.instance.insertTask(taskController.text, selectedDate.toLocal().toString().split(' ')[0], formatTimeOfDay(selectedTime));
    Navigator.pop(context);
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
                      "ADD TASK",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(width: 45)
                  ],
                ),

                // task
                SizedBox(height: 30),
                TextField(
                  focusNode: focusNode,
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: 'I have to',
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
                      'on ',
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
                      'at ',
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
                              "SAVE",
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
