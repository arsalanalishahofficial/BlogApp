import 'dart:io';

import 'package:blogapp/utils/colors.dart';
import 'package:blogapp/utils/styles.dart';
import 'package:blogapp/utils/toast.dart';
import 'package:blogapp/widgets/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _image;
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode titlefocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    titlefocusNode.addListener(() => setState(() {}));
    descriptionFocusNode.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titlefocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    titlefocusNode.dispose();

    descriptionController.dispose();
    descriptionFocusNode.dispose();

    super.dispose();
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                ),

                InkWell(
                  onTap: () {
                    getImageGallary();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallary'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageGallary() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        showToast("no image selected");
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        showToast("no image selected");
      }
    });
  }

  Future<void> _submit() async {
    setState(() {
      showSpinner = true;
    });

    try {
      int date = DateTime.now().millisecondsSinceEpoch;
      // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      //     .ref('/blogapp$date');
      // firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

      // await Future.value(uploadTask);

      // var url = await ref.getDownloadURL();
      final User? user = _auth.currentUser;

      await postRef
          .child("Post List")
          .child(date.toString())
          .set({
            'pId': date.toString(),
            // 'pImage' : url,
            'pTime': date.toString(),
            'pTitle': titleController.text.toString(),
            'pDescription': descriptionController.text.toString(),
            'pEmail': user!.email.toString(),
            'pUid': user.uid.toString(),
          })
          .onError((error, stackTrace) {
            showToast(error.toString());
          });

      showToast("Blog Published");
    } catch (e) {
      showToast(e.toString());
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: Text("Upload Blogs"), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: _image != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1, color: gray),
                              ),
                              child: ClipRect(
                                child: Image.file(
                                  _image!.absolute,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        focusNode: titlefocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(
                            context,
                          ).requestFocus(descriptionFocusNode);
                        },
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter Post Title",
                          border: OutlineInputBorder(),
                          hintStyle: hintStyle(),
                          labelStyle: labelStyle(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: descriptionController,
                        focusNode: descriptionFocusNode,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,

                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter post description",
                          border: OutlineInputBorder(),
                          hintStyle: hintStyle(),
                          labelStyle: labelStyle(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 10),
                      Roundedbutton(title: 'Upload', onPress: _submit),
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
