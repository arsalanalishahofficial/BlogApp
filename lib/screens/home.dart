import 'package:blogapp/routes/name_routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Blogs"),
        centerTitle: true,
        actions: [
          InkWell(onTap: () {
            Navigator.pushNamed(context, RouteName.AddPostScreen);
          }, child: Icon(Icons.add)),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(child: Column(children: [
          
        ],
      )),
    );
  }
}
