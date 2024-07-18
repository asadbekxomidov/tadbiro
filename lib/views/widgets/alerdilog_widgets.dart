import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';

class AlerDialogWidget extends StatefulWidget {
  final String event;
  AlerDialogWidget({required this.event});

  @override
  State<AlerDialogWidget> createState() => _AlerDialogWidgetState();
}

class _AlerDialogWidgetState extends State<AlerDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 460.h,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/alerdialogimages.png',
              height: 200.h,
              width: 200.w,
            ),
            SizedBox(height: 5.h),
            Text(
              'Tabriklaymiz!',
              style: TextStyle(
                fontSize: 18.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              widget.event,
              style: TextStyle(
                fontSize: 16.h,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Eslatma Belgilash",
                style: TextStyle(
                  fontSize: 12.h,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.orange.shade500,
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Bosh Sahifa",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade600, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [],
    );
  }
}
