import 'package:flutter/material.dart';

InputDecoration kInputDecoration =  InputDecoration(
    fillColor: Color(0xffD5D5D5).withOpacity(0.25),
    filled: true,
    border: InputBorder.none,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8.0)),
    hintStyle: TextStyle(
      color: Colors.grey,
    )
);