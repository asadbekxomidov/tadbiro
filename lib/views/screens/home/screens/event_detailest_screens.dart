// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';
import 'package:tadbiro/views/widgets/addshowmodelshett_widgets.dart';

class EventDetailsScreens extends StatefulWidget {
  EventModel event;
  EventDetailsScreens({required this.event});

  @override
  State<EventDetailsScreens> createState() => _EventDetailsScreensState();
}

class _EventDetailsScreensState extends State<EventDetailsScreens> {
  late GoogleMapController myController;
  MapType mapType = MapType.normal;
  Set<Marker> marker = {};
  LatLng latLng = const LatLng(41, 62);
  void onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      latLng = LatLng(widget.event.lat.toDouble(), widget.event.lng.toDouble());
      marker.add(
        Marker(
          markerId: const MarkerId("event"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    setState(() {});
  }

  int countUsersEvent = 0;
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
  bool isEventFinished(DateTime eventDate, String eventTime) {
    // Vaqtni "HH:mm" formatda Stringdan ajratish
    final timeParts = eventTime.split(':');
    final eventHour = int.parse(timeParts[0]);
    final eventMinute = int.parse(timeParts[1]);

    // Tadbir vaqtini DateTime formatiga o'tkazish
    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventHour,
      eventMinute,
    );

    return eventDateTime.isBefore(DateTime.now());
  }

  final userFirebaseServices = UsersFirebaseServices();
  final eventFirebaseServices = MyEventFirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: userFirebaseServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("ma'lumot topilmadi"),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Xatolik bor qaytadan urinib koring'),
            );
          }
          final user = snapshot.data;
          return Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(widget.event.imageUrl),
                        fit: BoxFit.cover,
                      )),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      SizedBox(width: 10.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MainScreen()));
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.event.title),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.teal.shade200),
                              child: Center(
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${months[widget.event.date.month - 1]} ${widget.event.date.day}, ${widget.event.date.year}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Time: ${widget.event.time}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.teal.shade200),
                              child: Center(
                                child: Icon(
                                  Icons.place,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "${widget.event.latlngNames.split(" ")[1]} ${widget.event.latlngNames.split(" ")[2]}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.teal.shade200),
                              child: Center(
                                child: Icon(
                                  Icons.people,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "${widget.event.amoutEventUSers} kishi bormoqda",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Siz ham ro'yxatdab o'ting",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Container(
                              height: 80.h,
                              width: 320.w,
                              child: StreamBuilder(
                                stream: userFirebaseServices
                                    .getUserById(widget.event.creatorId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Text("ma'lumot topilmadi"),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Xatolik bor qaytadan urinib koring',
                                      ),
                                    );
                                  }
                                  final userevent = snapshot.data;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                          userevent!['imageUrl'],
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userevent['firstname']} ${userevent['lastname']}",
                                            style: TextStyle(
                                              fontSize: 15.h,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "Tadbir tashkilotchisi",
                                            style: TextStyle(
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tadbir haqida",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.h),
                              ),
                              Text(
                                widget.event.description,
                                style: TextStyle(
                                  fontSize: 16.h,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "Manzil",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.h),
                              ),
                              Text(
                                "${widget.event.latlngNames.split(" ")[1]} ${widget.event.latlngNames.split(" ")[2]}",
                                style: TextStyle(
                                  fontSize: 16.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          clipBehavior: Clip.hardEdge,
                          width: double.infinity,
                          height: 300.h,
                          child: GoogleMap(
                            gestureRecognizers: Set()
                              ..add(Factory<EagerGestureRecognizer>(
                                  () => EagerGestureRecognizer())),
                            markers: marker,
                            mapType: mapType,
                            initialCameraPosition:
                                CameraPosition(target: latLng, zoom: 10),
                            onMapCreated: onMapCreated,
                          ),
                        ),
                        SizedBox(height: 15),
                        // !user!['ishtiroketilganlar'].contains(widget.event.id)
                        !user!['ishtiroketilganlar'].contains(widget.event.id)
                            ? isEventFinished(
                                    widget.event.date, widget.event.time)
                                // ? widget.event.date.isBefore(DateTime.now()) && widget.event.time.isBefore(DateTime.now())
                                ? InkWell(
                                    child: Container(
                                      height: 60.h,
                                      width: 350.w,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.amber.shade900,
                                              width: 5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Tadbir Yakunlandi",
                                          style: TextStyle(fontSize: 16.h),
                                        ),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return ModalBottonSheetScreens(
                                                event: widget.event,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: 350.w,
                                          decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              border: Border.all(
                                                  color: Colors.amber.shade900,
                                                  width: 5),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "Royxatdan O'tish",
                                              style: TextStyle(fontSize: 16.h),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            : Column(
                                children: [
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      userFirebaseServices
                                          .cancelEvent(widget.event.id);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => MainScreen()));
                                    },
                                    child: Container(
                                      height: 60.h,
                                      width: 350.w,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.amber.shade900,
                                              width: 5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Bekor Qilish",
                                          style: TextStyle(fontSize: 16.h),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // InkWell(
                                  //   child: Container(
                                  //     height: 60.h,
                                  //     width: 350.w,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color: Colors.amber.shade900,
                                  //             width: 5),
                                  //         borderRadius:
                                  //             BorderRadius.circular(10)),
                                  //     child: Center(
                                  //       child: Text(
                                  //         "Tadbir Yakunlandi",
                                  //         style: TextStyle(fontSize: 16.h),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
