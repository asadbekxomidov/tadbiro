// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:tadbiro/services/user_firestore_services.dart';
// import 'package:tadbiro/utils/messages_screen.dart';

// class UserAddScreen extends StatefulWidget {
//   const UserAddScreen({super.key});

//   @override
//   State<UserAddScreen> createState() => _UserAddScreenState();
// }

// class _UserAddScreenState extends State<UserAddScreen> {
//   final emailController = TextEditingController();
//   final lastnameController = TextEditingController();
//   final firstnameController = TextEditingController();
//   final locationController = TextEditingController();
//   File? imageFile;

//   void addUser() async {
//     if (emailController.text.isEmpty ||
//         lastnameController.text.isEmpty ||
//         firstnameController.text.isEmpty ||
//         imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Iltimos, barcha maydonlarni to\'ldiring va rasm yuklang')),
//       );
//       return;
//     }

//     Messages.showLoadingDialog(context);

//     await context.read<UserFireStoreServices>().addUser(
//           FirebaseAuth.instance.currentUser!.uid,
//           '${firstnameController.text} ${lastnameController.text}',
//           emailController.text,
//           locationController.text,
//           0.0,
//           0.0,
//           imageFile,
//         );

//     if (context.mounted) {
//       emailController.clear();
//       lastnameController.clear();
//       firstnameController.clear();
//       locationController.clear();
//       Navigator.pop(context);
//       Navigator.pop(context);
//     }
//   }

//   void openGallery() async {
//     final imagePicker = ImagePicker();
//     final XFile? pickedImage = await imagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       requestFullMetadata: false,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   void openCamera() async {
//     final imagePicker = ImagePicker();
//     final XFile? pickedImage = await imagePicker.pickImage(
//       source: ImageSource.camera,
//       requestFullMetadata: false,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         imageFile = File(pickedImage.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Foydalanuvchi Qo'shish"),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Email",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: lastnameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Familiya",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: firstnameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Ism",
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: locationController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Joriy joylashuv",
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Rasm Qo'shish",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton.icon(
//                   onPressed: openCamera,
//                   label: const Text("Kamera"),
//                   icon: const Icon(Icons.camera),
//                 ),
//                 TextButton.icon(
//                   onPressed: openGallery,
//                   label: const Text("Galleriya"),
//                   icon: const Icon(Icons.image),
//                 ),
//               ],
//             ),
//             if (imageFile != null)
//               SizedBox(
//                 height: 200,
//                 child: Image.file(
//                   imageFile!,
//                   fit: BoxFit.cover,
//                 ),
//               )
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text("Bekor Qilish"),
//         ),
//         ElevatedButton(
//           onPressed: addUser,
//           child: const Text("Saqlash"),
//         ),
//       ],
//     );
//   }
// }
