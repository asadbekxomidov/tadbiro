// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class MyEventFirebaseServices {
  final eventsCollection = FirebaseFirestore.instance.collection('events');
  final eventsImagesStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getEvents() async* {
    yield* eventsCollection.snapshots();
  }

  Future<void> addEvent(
    String creatorId,
    String title,
    String description,
    String date,
    String time,
    File? imageUrl,
    List<String> visitorsId,
    List<String> likedUsersId,
    num lat,
    num lng,
    String latlngNames,
    // int amoutEventUSers  0,
  ) async {
    if (imageUrl != null) {
      final imageReference = eventsImagesStorage
          .ref()
          .child("events")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");

      final uploadTask = await imageReference.putFile(imageUrl);

      final imageUrlDownload = await imageReference.getDownloadURL();

      await eventsCollection.add({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': imageUrlDownload,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        "latlngNames": latlngNames,
        "amoutEventUSers": 0,
      });
    } else {
      await eventsCollection.add({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': null,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        "latlngNames": latlngNames,
        // "amoutEventUSers": amoutEventUSers,
      });
    }
  }

  Future<void> editEvent(
    String id,
    String creatorId,
    String title,
    String description,
    String date,
    String time,
    File? imageUrl,
    List<String> visitorsId,
    List<String> likedUsersId,
    num lat,
    num lng,
    String latlngNames,
    // int amoutEventUSers,
  ) async {
    if (imageUrl != null) {
      final imageReference = eventsImagesStorage
          .ref()
          .child("events")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");

      final uploadTask = await imageReference.putFile(imageUrl);

      final imageUrlDownload = await imageReference.getDownloadURL();

      await eventsCollection.doc(id).update({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': imageUrlDownload,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        "latlngNames": latlngNames,
        // "amoutEventUSers": amoutEventUSers,
      });
    } else {
      await eventsCollection.doc(id).update({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': null,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        "latlngNames": latlngNames,
        // "amoutEventUSers": amoutEventUSers,
      });
    }
  }

  Future<void> deleteEvent(String id) async {
    await eventsCollection.doc(id).delete();
  }

  Future<void> usersEventAdd(
      String eventId, String visitorId, int usersEventAmount) async {
    final eventBox = await eventsCollection.doc(eventId).get();
    final event = eventBox.data();
    event!['visitorsId'].add(visitorId);
    event['amoutEventUSers'] += usersEventAmount;
    eventsCollection.doc(eventId).update({
      "visitorsId": event['visitorsId'],
      'amoutEventUSers': event['amoutEventUSers']
    });
  }
}
