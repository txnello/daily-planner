// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dailyplanner/widgets/custom-checkbox.dart';
import 'package:flutter/material.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<bool> checkedStatus = [true, false, false, false];

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
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 35,
                    )
                  ],
                ),

                // date
                Text(
                  "22 Aprile",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),

                Text(
                  "Sunday",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),

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

                CustomCheckBox(
                  time: "11:43 PM",
                  task:
                      "The first Flexible wrapping your main Column sets the layout for its direct children, that's why the first Text works, because it's a direct child (layout wise) of the Column. But then you add a Row which sets its own children's layout, and the overflow won't work because it doesn't has any width constraint, by wrapping that Text in a Flexible you tell it to grab all the space it can up to its parent width, and apply whatever TextOverflow you need, ellipsis in this case.",
                  cheked: checkedStatus[2],
                ),

                CustomCheckBox(
                  time: "11:43 PM",
                  task:
                      "The first Flexible wrapping your main Column sets the layout for its direct children, that's why the first Text works, because it's a direct child (layout wise) of the Column. But then you add a Row which sets its own children's layout, and the overflow won't work because it doesn't has any width constraint, by wrapping that Text in a Flexible you tell it to grab all the space it can up to its parent width, and apply whatever TextOverflow you need, ellipsis in this case.",
                  cheked: checkedStatus[3],
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
