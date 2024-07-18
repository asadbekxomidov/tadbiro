// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/home/screens/event_detailest_screens.dart';
import 'package:tadbiro/views/screens/ui/notification_screens.dart';
import 'package:tadbiro/views/widgets/custom_drawer_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  bool isBig = false;

  final eventFirebaseServices = MyEventFirebaseServices();
  final usersFirebaseServices = UsersFirebaseServices();

  TextEditingController searchController = TextEditingController();
  Timer? debounce;
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Bosh sahifa"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => NotificationScreens()));
            },
            icon: Icon(
              Icons.notifications_none_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  border: const OutlineInputBorder(),
                  hintText: "Tadbirlarni izlash...",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 16.h),
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
                  suffixIcon: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(child: Text("Tadbir nomi bo'yicha")),
                        PopupMenuItem(child: Text("Manzil bo'yicha")),
                      ];
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Yaqin 7 kun ichida',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10),
              Container(
                height: 240.h,
                width: 400.w,
                child: StreamBuilder(
                    stream: usersFirebaseServices
                        .getUserById(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Xatolik bor'),
                        );
                      }
                      final user = snapshot.data;
                      return StreamBuilder(
                        stream: eventFirebaseServices.getEvents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Xatolik bor'),
                            );
                          }

                          final events = snapshot.data?.docs ?? [];
                          final now = DateTime.now();
                          final sevenDaysLater = now.add(Duration(days: 7));

                          final recentEvents = events
                              .map((doc) => EventModel.fromQuery(doc))
                              .where((event) {
                            final eventDate = event.date;
                            final matchesQuery = event.title
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()) ||
                                event.latlngNames
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                            return eventDate.isAfter(now) &&
                                eventDate.isBefore(sevenDaysLater) &&
                                matchesQuery;
                          }).toList();

                          if (recentEvents.isEmpty) {
                            return Center(
                              child: Text(
                                  "Yaqinda bo'ladigan Tadbirlar mavjud emas"),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recentEvents.length,
                            itemBuilder: (context, index) {
                              final event = recentEvents[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => EventDetailsScreens(
                                              event: event)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  height: 220.h,
                                  width: 340.w,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(event.imageUrl),
                                        fit: BoxFit.cover,
                                      )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${event.date.day}",
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "${months[event.date.month - 1]}",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        event.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 18.h,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
              SizedBox(height: 10),
              Text('Barcha Tadbirlar'),
              SizedBox(height: 10),
              Container(
                height: 400.h,
                child: StreamBuilder(
                    stream: usersFirebaseServices
                        .getUserById(FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Xatolik bor'),
                        );
                      }
                      return StreamBuilder(
                        stream: eventFirebaseServices.getEvents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Xatolik bor'),
                            );
                          }
                          final events = snapshot.data?.docs ?? [];
                          final filteredEvents = events
                              .map((doc) => EventModel.fromQuery(doc))
                              .where((event) {
                            return event.title
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()) ||
                                event.latlngNames
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                          }).toList();
                          return ListView.builder(
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => EventDetailsScreens(
                                              event: event)));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 3),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Image.network(
                                          event.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    event.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isBig = !isBig;
                                                      });
                                                    },
                                                    icon: isBig != true
                                                        ? Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border_outlined,
                                                            color: Colors.green,
                                                          ))
                                              ],
                                            ),
                                            Text(
                                              "${event.time}  ${months[event.date.month - 1]} ${event.date.day}, ${event.date.year}",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.place_outlined),
                                                Text(
                                                  event.latlngNames
                                                      .toString()
                                                      .split(',')[1],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
