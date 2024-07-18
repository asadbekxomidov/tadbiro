import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/services/location_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';

// ignore: must_be_immutable
class UserAddWidgets extends StatefulWidget {
  const UserAddWidgets({super.key});

  @override
  State<UserAddWidgets> createState() => _UserAddWidgetsState();
}

class _UserAddWidgetsState extends State<UserAddWidgets> {
  final formKey = GlobalKey<FormState>();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

  final fnameController = TextEditingController();

  final lnameController = TextEditingController();

  bool isLoading = false;
  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        final curUser = FirebaseAuth.instance.currentUser;
        final curLocation = await LocationServices.getCurrentLocation();
        usersFirebaseServices.addUser(
          curLocation.latitude,
          curLocation.longitude,
          fnameController.text,
          lnameController.text,
          curUser!.email!,
          imageFile,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return MainScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(message),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                if (imageFile != null)
                  Container(
                    height: 260.h,
                    width: 260.w,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: fnameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: const OutlineInputBorder(),
                    hintText: "Ismingiz",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Iltimos ismingizni kiriting";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Familyangiz",
                    prefixIcon: Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.5)),
                      borderSide: BorderSide(
                        color: Colors.amber.shade900,
                        width: 3.w,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Iltimos ismingizni kiriting";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        openGallery();
                      },
                      child: Container(
                        height: 55.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.shade900,
                              width: 3.w,
                            )),
                        child: Center(
                          child: Text('Galleriya'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        openCamera();
                      },
                      child: Container(
                        height: 55.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.amber.shade900,
                              width: 3.w,
                            )),
                        child: Center(
                          child: Text('Kamera'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () async {
                    submit();
                  },
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.shade900,
                          width: 3.w,
                        )),
                    child: Center(
                      child: Text('Kirish'),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     submit();
                //   },
                //   child: Text(
                //     "Continue",
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.deepPurple,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
