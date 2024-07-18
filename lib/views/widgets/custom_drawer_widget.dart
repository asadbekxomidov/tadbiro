import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro/controller/theme_controller.dart';
import 'package:tadbiro/models/users_model.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/auth/login_screen.dart';
import 'package:tadbiro/views/screens/drawer/my_tadbiro_screen.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';
import 'package:tadbiro/views/screens/ui/edit_users_screens.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userFirebaseService = UsersFirebaseServices();
  User? _user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        if (user != null) {
          _checkTokenValidity(user);
        }
      });
    });
  }

  Future<void> _checkTokenValidity(User user) async {
    try {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      DateTime? expirationTime = tokenResult.expirationTime;
      if (expirationTime != null && expirationTime.isBefore(DateTime.now())) {
        auth.signOut();
      }
    } catch (e) {
      print('Tokenning amal qilish muddatini tekshirishda xato: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeModeController>(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                height: 260,
                width: double.infinity,
                color: Colors.teal,
                child: _user == null
                    ? Center(child: Text('Foydalanuvchi topilmadi'))
                    : StreamBuilder<DocumentSnapshot>(
                        stream: userFirebaseService.getUserById(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child:
                                  Text('Xatolik yuz berdi: ${snapshot.error}'),
                            );
                          }

                          final userDoc = snapshot.data!;
                          final user = UserModel.fromDocumentSnapshot(userDoc);
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user.imageUrl.isNotEmpty)
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(user.imageUrl),
                                  ),
                                SizedBox(height: 10),
                                Text(
                                  '${user.firstname} ${user.lastname}',
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => MainScreen()));
                },
                leading: Icon(Icons.home),
                title: Text('Bosh Sahifa'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => MyTadbiroScreen()));
                },
                leading: Icon(Icons.event),
                title: Text('Mening tadbirlarim'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => EditUsersScreens()));
                },
                leading: Icon(Icons.person_2_outlined),
                title: Text("Profil Ma'lumotlari"),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text("Tillarni o'zgartirish"),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              ListTile(
                onTap: () {
                  themeController.toggleThemeMode();
                },
                leading: Icon(Icons.sunny),
                title: Text('Tungi / kunduzgi holat'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          ListTile(
            onTap: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Chiqish'),
            trailing: Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
