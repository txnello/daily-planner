// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomDate extends StatefulWidget {
  final String date;
  final String day;

  const CustomDate({super.key, required this.date, required this.day});

  @override
  State<CustomDate> createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.date,
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.day,
          style: TextStyle(fontSize: 22, color: Colors.grey),
        ),
      ],
    );
  }
}
