import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/models/users_model.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:random_string/random_string.dart';
import 'package:tadbiro/views/widgets/custom_drawer_widget.dart';

class EditUsersScreens extends StatefulWidget {
  const EditUsersScreens({super.key});

  @override
  State<EditUsersScreens> createState() => _EditUsersScreensState();
}

class _EditUsersScreensState extends State<EditUsersScreens> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final userFireStoreServices = UsersFirebaseServices();

  File? imageFile;

  @override
  void initState() {
    super.initState();
    // _loadUserData();
  }

  // void _loadUserData() async {
  //   // final userId = FirebaseAuth.instance.currentUser!.uid;
  //   // final user = await userFireStoreServices.getUserById(userId);
  //   setState(() {
  //     // firstnameController.text = user['firstname'] ?? '';
  //     // lastnameController.text = user['lastname'] ?? '';
  //   });
  // }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

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
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> editUser(
      String firstname, String lastname, String userId, File? image) async {
    final userDoc =
        await userFireStoreServices.usersCollection.doc(userId).get();
    final user = userDoc.data()!;
    user['firstname'] = firstname;
    user['lastname'] = lastname;

    if (image != null) {
      final imageReference = userFireStoreServices.usersImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");
      final uploadTask = imageReference.putFile(
        image,
      );

      uploadTask.snapshotEvents.listen((status) {});

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        user['imageUrl'] = imageUrl;
        await userFireStoreServices.usersCollection.doc(userId).update({
          'firstname': user['firstname'],
          'lastname': user['lastname'],
          'imageUrl': user['imageUrl'],
        });
      });
    } else {
      await userFireStoreServices.usersCollection.doc(userId).update({
        'firstname': user['firstname'],
        'lastname': user['lastname'],
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User information updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Foydalanuvchi ma'lumot",
          style: TextStyle(
            fontSize: 20.h,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userFireStoreServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Xatolik yuz berdi: ${snapshot.error}'),
            );
          }
          final userDoc = snapshot.data!;
          final user = UserModel.fromDocumentSnapshot(userDoc);
          firstnameController.text = user.firstname;
          lastnameController.text = user.lastname;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  if (user.imageUrl.isNotEmpty)
                    Container(
                      height: 160.h,
                      width: 160.w,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl),
                            fit: BoxFit.cover,
                          )),
                    ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: firstnameController,
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
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: lastnameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      hintText: "Familiya",
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
                  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: openGallery,
                        child: Container(
                          height: 50.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(
                                color: Colors.amber.shade900, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Galereya",
                              style: TextStyle(
                                  fontSize: 18.h, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: openCamera,
                        child: Container(
                          height: 50.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(
                                color: Colors.amber.shade900, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Kamera",
                              style: TextStyle(
                                  fontSize: 18.h, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await editUser(
                        firstnameController.text,
                        lastnameController.text,
                        FirebaseAuth.instance.currentUser!.uid,
                        imageFile,
                      );
                    },
                    child: Container(
                      height: 55.h,
                      width: 360.w,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border:
                            Border.all(color: Colors.amber.shade900, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "O'zgartirish",
                          style: TextStyle(
                              fontSize: 18.h, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await editUser(
                  //       firstnameController.text,
                  //       lastnameController.text,
                  //       FirebaseAuth.instance.currentUser!.uid,
                  //       imageFile,
                  //     );
                  //   },
                  //   child: Text('Update'),
                  // ),
                  // SizedBox(height: 20),
                  // Text(
                  //   '${user.firstname} ${user.lastname}',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 5),
                  // Text(
                  //   user.email,
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
