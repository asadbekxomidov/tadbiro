import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/views/screens/drawer/widgets/widgets/add_event_screens.dart';
import 'package:tadbiro/views/screens/drawer/widgets/widgets/edit_event_screens.dart';

class TashkilQilinganlar extends StatefulWidget {
  @override
  State<TashkilQilinganlar> createState() => _TashkilQilinganlarState();
}

class _TashkilQilinganlarState extends State<TashkilQilinganlar> {
  final eventsServices = MyEventFirebaseServices();
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
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          final events = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = EventModel.fromQuery(events[index]);

              if (event.creatorId == curUser) {
                // return StreamBuilderWidget(event: event);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 3),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            event.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert_outlined),
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem<String>(
                                          value: 'Tahrirlash',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EditEventWidgets(
                                                        event: event),
                                              ),
                                            );
                                          },
                                          child: Text('Tahrirlash'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: "O'chirish",
                                          onTap: () async {
                                            await eventsServices
                                                .deleteEvent(event.id);
                                          },
                                          child: Text("O'chirish"),
                                        ),
                                      ];
                                    },
                                  ),
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
                                    event.latlngNames.toString().split(',')[1],
                                    overflow: TextOverflow.ellipsis,
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
              } else {
                return SizedBox();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber.shade200,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddEventWidgets()),
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.amber.shade900,
        ),
      ),
    );
  }
}
