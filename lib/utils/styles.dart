import 'package:flutter/material.dart';

TextStyle headingStyle({
  double size = 30,
  Color color = Colors.black,
  FontWeight weight = FontWeight.bold,
}) => TextStyle(fontSize: 30.0, color: Colors.deepOrange, fontWeight: weight);

double iconSize({double size = 20}) => size;

TextStyle labelStyle() => TextStyle(color: Colors.grey,fontWeight: FontWeight.normal);
TextStyle hintStyle() => TextStyle(color: Colors.grey,fontWeight: FontWeight.normal);