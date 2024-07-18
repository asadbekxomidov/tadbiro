import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/home/screens/event_detailest_screens.dart';
import 'package:tadbiro/views/widgets/stream_builder_widgets.dart';

class YaqindaWidgets extends StatefulWidget {
  @override
  State<YaqindaWidgets> createState() => _YaqindaWidgetsState();
}

class _YaqindaWidgetsState extends State<YaqindaWidgets> {
  final eventsServices = MyEventFirebaseServices();

  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

  final curUser = FirebaseAuth.instance.currentUser!.uid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: eventsServices.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Malumotlar topilmadi"),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final events = snapshot.data!.docs;
          return StreamBuilder(
            stream: usersFirebaseServices.getUserById(curUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Malumotlar topilmadi"),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              final user = snapshot.data;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = EventModel.fromQuery(events[index]);
                  if (user!['ishtiroketilganlar'].contains(event.id) &&
                      event.date.isAfter(DateTime.now())) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  EventDetailsScreens(event: event)),
                        );
                      },
                      child: StreamBuilderWidget(event: event),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
