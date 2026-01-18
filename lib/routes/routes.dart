import 'package:blogapp/routes/name_routes.dart';
import 'package:blogapp/screens/addPost.dart';
import 'package:blogapp/screens/forgetpassword.dart';
import 'package:blogapp/screens/home.dart';
import 'package:blogapp/screens/optionScreen.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:blogapp/screens/signup.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.signinScreen:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case RouteName.signupScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteName.optionScreen:
        return MaterialPageRoute(builder: (_) => Optionscreen());
      case RouteName.AddPostScreen:
        return MaterialPageRoute(builder: (_) => AddPostScreen());
      case RouteName.forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgetpasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text("No Routes available"))),
        );
    }
  }
}
