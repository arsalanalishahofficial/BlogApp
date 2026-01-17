import 'package:blogapp/routes/name_routes.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:blogapp/screens/signup.dart';
import 'package:blogapp/widgets/roundedButton.dart';
import 'package:flutter/material.dart';

class Optionscreen extends StatelessWidget {
  const Optionscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image(
                  image: AssetImage("assets/images/logo.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
              Roundedbutton(
                title: "Login",
                onPress: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.signinScreen
                  );
                },
              ),
              Roundedbutton(title: "Register", onPress: () {
                 Navigator.pushReplacementNamed(
                    context,
                    RouteName.signupScreen,
                  );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
