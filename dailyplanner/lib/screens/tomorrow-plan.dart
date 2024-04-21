// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:dailyplanner/screens/addTask.dart';
import 'package:dailyplanner/screens/plan.dart';
import 'package:dailyplanner/widgets/custom-checkbox.dart';
import 'package:dailyplanner/widgets/custom-date.dart';
import 'package:flutter/material.dart';

class TomorrowPlan extends StatefulWidget {
  const TomorrowPlan({super.key});

  @override
  State<TomorrowPlan> createState() => _TomorrowPlanState();
}

class _TomorrowPlanState extends State<TomorrowPlan> {
  List<bool> checkedStatus = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => AddTask(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white,),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Plan(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                          ),
                          (r) => false
                        );
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 35,
                      ),
                    )
                  ],
                ),

                // date
                CustomDate(date: "23 Aprile", day: "Sunday"),

                GestureDetector(
                    onTap: () {
                      setState(() {
                        checkedStatus[0] = !checkedStatus[0];
                      });
                    },
                    child: CustomCheckBox(
                      time: "08:22 AM",
                      task: "Lavare auto",
                      cheked: checkedStatus[0],
                    )),

                CustomCheckBox(
                  time: "11:43 PM",
                  task:
                      "The first Flexible wrapping your main Column sets the layout for its direct children, that's why the first Text works, because it's a direct child (layout wise) of the Column. But then you add a Row which sets its own children's layout, and the overflow won't work because it doesn't has any width constraint, by wrapping that Text in a Flexible you tell it to grab all the space it can up to its parent width, and apply whatever TextOverflow you need, ellipsis in this case.",
                  cheked: checkedStatus[1],
                ),

                SizedBox(height: 85)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
