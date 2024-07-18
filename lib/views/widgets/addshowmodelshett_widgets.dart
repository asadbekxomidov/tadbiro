// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/widgets/alerdilog_widgets.dart';

class ModalBottonSheetScreens extends StatefulWidget {
  EventModel event;
  ModalBottonSheetScreens({required this.event});
  @override
  State<ModalBottonSheetScreens> createState() => _ModalBottonSheetScreensState();
}

class _ModalBottonSheetScreensState extends State<ModalBottonSheetScreens> {
  final MyEventFirebaseServices eventsFirebaseServices =
      MyEventFirebaseServices();
  final UsersFirebaseServices userstsFirebaseServices = UsersFirebaseServices();
  int amoutUsersCount = 0;

  int? addIndexUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_sharp,
                  ),
                ),
              ),
              const Text(
                "Ro'yxatdan o'tish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Joylar Sonini Tanlang",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: IconButton(
                  onPressed: () {
                    if (amoutUsersCount > 0) {
                      setState(() {
                        amoutUsersCount -= 1;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.remove,
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "$amoutUsersCount",
                style: TextStyle(
                  fontSize: 16.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      amoutUsersCount += 1;
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "To'lov Turini Tanlang",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () {
              setState(() {
                addIndexUser = 0;
              });
            },
            tileColor: Colors.white,
            minVerticalPadding: 10,
            leading: Container(
              height: 30,
              width: 30,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                10,
              )),
              child: Image.network(
                "https://static10.tgstat.ru/channels/_0/56/5658e449ee736d57903551c4b5347183.jpg",
                fit: BoxFit.cover,
              ),
            ),
            title: const Text(
              "Click",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: addIndexUser == 0
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.circle_outlined,
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              setState(() {
                addIndexUser = 1;
              });
            },
            tileColor: Colors.white,
            minVerticalPadding: 10,
            leading: Container(
              height: 30,
              width: 30,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                10,
              )),
              child: Image.network(
                "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/b4/3e/c8/b43ec8b3-e314-61ee-44f1-9d2f4f2fcc57/AppIcon-0-0-1x_U007emarketing-0-0-0-8-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/600x600wa.png",
                fit: BoxFit.cover,
              ),
            ),
            title: const Text(
              "Payme",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: addIndexUser == 1
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.circle_outlined,
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              setState(() {
                addIndexUser = 2;
              });
            },
            tileColor: Colors.white,
            minVerticalPadding: 10,
            leading: Container(
              height: 30,
              width: 30,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                10,
              )),
              child: Image.network(
                "https://mkbank.uz/upload/iblock/1f5/09beunquux1q40m9c3y4qz6m35r60k3k/naqd-pulda_no_bg1.webp",
                // "https://i.artfile.ru/2560x1600_1287486_[www.ArtFile.ru].jpg",
                fit: BoxFit.cover,
              ),
            ),
            title: const Text(
              "Naqd",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: addIndexUser == 2
                ? const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.circle_outlined,
                  ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await eventsFirebaseServices.usersEventAdd(widget.event.id,
                      FirebaseAuth.instance.currentUser!.uid, amoutUsersCount);
                  userstsFirebaseServices.participatedEvents(widget.event.id);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlerDialogWidget(
                        event: widget.event.title,
                      );
                    },
                  );
                },
                child: const Text(
                  "Keyingi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.orange.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
