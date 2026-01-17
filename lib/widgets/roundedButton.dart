import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;


  const Roundedbutton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.deepOrange,
        minWidth: double.infinity,
        onPressed: onPress,
        child: Text(title, style: TextStyle(color: Colors.white),),
        ),       
    );
  }
}