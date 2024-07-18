import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro/models/tadbiro.dart';
import 'package:tadbiro/services/my_event_firebase_services.dart';
import 'package:tadbiro/services/user_firestore_services.dart';
import 'package:tadbiro/views/screens/home/screens/event_detailest_screens.dart';

class IshtiroketilganlarWidget extends StatelessWidget {
  const IshtiroketilganlarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsServices = MyEventFirebaseServices();
    final userServices = UsersFirebaseServices();
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

    return Scaffold(
      body: StreamBuilder(
        stream: userServices.getUserById(curUser),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!userSnapshot.hasData) {
            return Center(
              child: Text("Ma'lumotlar topilmadi"),
            );
          }
          final userDoc = userSnapshot.data!;
          final user = userDoc.data() as Map<String, dynamic>;
          final List ishtiroketilganlar = user['ishtiroketilganlar'];

          return StreamBuilder(
            stream: eventsServices.getEvents(),
            builder: (context, eventSnapshot) {
              if (eventSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!eventSnapshot.hasData) {
                return Center(
                  child: Text("Ma'lumotlar topilmadi"),
                );
              }

              if (eventSnapshot.hasError) {
                return Center(
                  child: Text(eventSnapshot.error.toString()),
                );
              }

              final events = eventSnapshot.data!.docs;

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = EventModel.fromQuery(events[index]);

                  if (ishtiroketilganlar.contains(event.id)) {
                    final isPastEvent = event.date.isBefore(DateTime.now());

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    EventDetailsScreens(event: event)),
                          );
                        },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                      ],
                                    ),
                                    Text(
                                      "${event.time} ${months[event.date.month - 1]} ${event.date.day}, ${event.date.year}",
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
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isPastEvent)
                                      InkWell(
                                        onTap: () {
                                          // Nothing should happen
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 8.0),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            border: Border.all(
                                                color: Colors.red, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Tadbir Yakunlandi",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
