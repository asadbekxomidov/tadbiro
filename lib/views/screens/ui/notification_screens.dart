import 'package:flutter/material.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';

class NotificationScreens extends StatelessWidget {
  const NotificationScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (ctx) => MainScreen()));
            },
            icon: Icon(Icons.arrow_back_ios_outlined)),
        centerTitle: true,
        title: Text('Xabarlar'),
      ),
    );
  }
}
