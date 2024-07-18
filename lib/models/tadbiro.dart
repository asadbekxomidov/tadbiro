import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String creatorId;
  String title;
  String time;
  DateTime date;
  String description;
  String imageUrl;
  List visitorsId;
  List likedUsersId;
  int amoutEventUSers;
  num lat;
  num lng;
  String latlngNames;

  EventModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.time,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.visitorsId,
    required this.likedUsersId,
    required this.lat,
    required this.lng,
    required this.latlngNames,
    required this.amoutEventUSers,
  });

  factory EventModel.fromQuery(QueryDocumentSnapshot query) {
    return EventModel(
      id: query.id,
      creatorId: query['creatorId'],
      title: query['title'],
      time: query['time'],
      date: DateTime.parse(query['date']),
      description: query['description'],
      imageUrl: query['imageUrl'] ?? 'https://archive.org/download/placeholder-image/placeholder-image.jpg',
      visitorsId: query['visitorsId'],
      likedUsersId: query['likedUsersId'],
      lat: query['lat'] as double,
      lng: query['lng'] as double,
      latlngNames: query['latlngNames'],
      amoutEventUSers: query['amoutEventUSers'],
    );
  }

  eventModeltoQuery(EventModel event) {
    return {
      "title": event.title,
      "time": event.time.toString(),
      'date': event.date.toString(),
      'description': event.description,
      'imageUrl': event.imageUrl,
      'visitorsId': event.visitorsId,
      'likedUsersId': event.likedUsersId,
      'lat': event.lat,
      "lng": event.lng,
      "latlngNames": event.latlngNames,
      "amoutEventUSers": event.amoutEventUSers,
    };
  }
}
