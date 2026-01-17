import 'package:blogapp/routes/name_routes.dart';
import 'package:blogapp/utils/colors.dart';
import 'package:blogapp/utils/styles.dart';
import 'package:blogapp/utils/toast.dart';
import 'package:blogapp/widgets/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController, passwordController;
  late final FocusNode emailfocusNode, passwordFocusNode;

  bool obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpiner = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailfocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailfocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailfocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailfocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        showSpiner = true;
      });
      final email = emailController.text.trim();
      final pass = passwordController.text.trim();

      try {
        final user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );

        if (user.user != null) {
          showToast('User successfully created');
        }
      } on FirebaseAuthException catch (e) {
        showToast(e.message ?? 'Authentication error');
      } catch (e) {
        showToast('An unexpected error occurred');
      } finally {
        setState(() => showSpiner = false);

        Navigator.pushReplacementNamed(context, RouteName.signinScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpiner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register an account'),
          centerTitle: true,
          backgroundColor: deepOrange,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Register", style: headingStyle()),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        focusNode: emailfocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            size: iconSize(),
                            color: emailfocusNode.hasFocus ? deepOrange : black,
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
                        onFieldSubmitted: (value) {
                          FocusScope.of(
                            context,
                          ).requestFocus(passwordFocusNode);
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            size: iconSize(),
                            color: passwordFocusNode.hasFocus
                                ? deepOrange
                                : black,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              size: iconSize(),
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: deepOrange),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Enter Password'
                            : value.length < 8
                            ? 'Password must be at least 8 characters'
                            : null,
                      ),

                      SizedBox(height: 20),

                      Roundedbutton(
                        title: "Login",
                        onPress: () {
                          _submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
