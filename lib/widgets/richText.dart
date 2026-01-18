import 'package:flutter/material.dart';

class RichText extends StatelessWidget {
  final String title;
  final String data;
  const RichText({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: data),
        ],
      ),
    );
  }
}
