import 'package:blogapp/routes/name_routes.dart';
import 'package:blogapp/screens/home.dart';
import 'package:blogapp/utils/colors.dart';
import 'package:blogapp/utils/styles.dart';
import 'package:blogapp/utils/toast.dart';
import 'package:blogapp/widgets/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController emailController, passwordController;
  late final FocusNode emailFocus, passwordFocus;

  bool obscureText = true;
  bool showSpiner = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailFocus = FocusNode();
    passwordFocus = FocusNode();

    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => emailFocus.requestFocus(),
    );
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      showSpiner = true;
    });

    final email = emailController.text.trim().toString();
    final pass = passwordController.text.trim();

    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      if (user.user != null) {
        showToast("User successfully login");
      } else {
        showToast("Invalid Username or Password");
      }
    } on FirebaseAuthException catch (e) {
      showToast(e);
    } catch (e) {
      showToast(e.toString());
    } finally {
      setState(() {
        showSpiner = false;
      });

      emailController.clear();
      passwordController.clear();

      Navigator.pushReplacementNamed(context, RouteName.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpiner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SignIn Your Account"),
          centerTitle: true,
          backgroundColor: deepOrange,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login', style: headingStyle()),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: emailController,
                        focusNode: emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            size: iconSize(),
                            color: emailFocus.hasFocus ? deepOrange : gray,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: deepOrange),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter email";
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return "Enter a valid email";
                          }
                        },

                        onFieldSubmitted: (value) =>
                            FocusScope.of(context).requestFocus(passwordFocus),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: obscureText,
                        controller: passwordController,
                        focusNode: passwordFocus,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            size: iconSize(),
                            color: passwordFocus.hasFocus ? deepOrange : gray,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: deepOrange),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "Enter Password"
                            : value.length < 8
                            ? "Password must be at least 8 characters"
                            : null,
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.forgetPasswordScreen);
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                      SizedBox(height: 30),
                      Roundedbutton(title: "SignIn", onPress: _submit),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
