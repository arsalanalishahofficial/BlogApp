import 'package:blogapp/widgets/richText.dart';
import 'package:flutter/material.dart' hide RichText;

class PostCard extends StatelessWidget {
  final Map data;
  const PostCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                title: 'Email:',
                data: data['pEmail']?.toString() ?? "No email",
              ),
              RichText(
                title: 'Title:',
                data: data['pTitle']?.toString() ?? "No Title",
              ),

              RichText(
                title: 'Description:',
                data: data['pDescription']?.toString() ?? "No Description",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
