import 'package:blogapp/utils/colors.dart';
import 'package:blogapp/utils/styles.dart';
import 'package:blogapp/utils/toast.dart';
import 'package:blogapp/widgets/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetpasswordScreen extends StatefulWidget {
  const ForgetpasswordScreen({super.key});

  @override
  State<ForgetpasswordScreen> createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  late TextEditingController emailController;
  late FocusNode emailFocusNode;
  bool showSpiner = false;

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    emailController = TextEditingController();
    emailFocusNode = FocusNode();
    emailFocusNode.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => emailFocusNode.requestFocus(),
    );
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      showSpiner = true;
    });

    try {
      
      await _auth
          .sendPasswordResetEmail(email: emailController.text.toString())
          .onError((error, stackTrace) {
            showToast(error.toString());
          });

      showToast(
        "If this email is registered, a reset link has been sent.",
      );
    } on FirebaseAuthException catch (e) {
      showToast(e.toString());
    } finally {
      setState(() {
        showSpiner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpiner,
      child: Scaffold(
        appBar: AppBar(title: Text("Forget Password"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          size: iconSize(),
                          color: emailFocusNode.hasFocus ? deepOrange : gray,
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
                    ),

                    SizedBox(height: 10),

                    Roundedbutton(title: "Recover Password", onPress: _submit),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
