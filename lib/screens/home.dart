import 'package:blogapp/routes/name_routes.dart';
import 'package:blogapp/widgets/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child("Posts");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Blogs"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteName.AddPostScreen);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 20),

          InkWell(
            onTap: () {
              _auth.signOut().then((value) {
                Navigator.pushNamed(context, RouteName.signinScreen);
              });
            },
            child: Icon(Icons.logout),
          ),

          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Search with blog title",
                  labelText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  search = value;
                },
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef.child("Post List"),
                  itemBuilder: (context, snapshot, animation, index) {
                    final data = snapshot.value as Map?;
                    if (data!.isNotEmpty) {
                      String tempTitle = data['title'].toString();
                      if (searchController.text.toString().isEmpty) {
                        return PostCard(data: data);
                      }
                      else if(tempTitle.toLowerCase().contains(searchController.text.toString())){
                        return PostCard(data: data);
                      }
                      else{
                        return Container();
                      }
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
