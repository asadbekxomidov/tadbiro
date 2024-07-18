// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class UsersFirebaseServices {
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final usersImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* usersCollection.snapshots();
  }

  Stream<DocumentSnapshot> getUserById(String id) {
    return usersCollection.doc(id).snapshots();
  }

  void addUser(double lat, double lng, String firstname, String lastname,
      String email, File? image) {
    if (image != null) {
      final imageReference = usersImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");
      final uploadTask = imageReference.putFile(
        image,
      );

      uploadTask.snapshotEvents.listen((status) {});

      uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
          'lat': lat,
          'lng': lng,
          'firstname': firstname,
          'lastname': lastname,
          "email": email,
          'imageUrl': imageUrl,
          'tashkiletilganlar': [],
          'ishtiroketilganlar': [],
          'bekorqilinganlar': [],
          'yaqinda': [],
          'isFavoriteEvents': [],
        });
      });
    }
  }

  Future<void> editUser(
      String firstname, String lastname, String userId, var image) async {
    final userssection = await usersCollection.doc(userId).get();
    final user = userssection.data();
    user!['firstname'] = firstname;
    user['lastname'] = lastname;
    if (image != null) {
      final imageReference = usersImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");
      final uploadTask = imageReference.putFile(
        image,
      );
      uploadTask.snapshotEvents.listen((status) {});
      uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        usersCollection.doc(userId).update({
          'firstname': user['firstname'],
          'lastname': user['lastname'],
          'imageUrl': user['imageUrl'],
        });
      });
    }
  }

  Future<void> userslikeEvent(String userId, String eventId) async {
    final userssection = await usersCollection.doc(userId).get();
    final user = userssection.data();
    user!['isFavoriteEvents'].add(eventId);
    await usersCollection
        .doc(userId)
        .update({'isFavoriteEvents': user['isFavoriteEvents']});
  }

  Future<void> favoriteRemove(String userId, String eventId) async {
    final userssection = await usersCollection.doc(userId).get();
    final user = userssection.data();
    user!['isFavoriteEvents'].removeWhere((e) {
      return e == eventId;
    });
    await usersCollection.doc(userId).update(
      {'isFavoriteEvents': user['isFavoriteEvents']},
    );
  }

  Future<void> participatedEvents(String eventId) async {
    final userssection =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    final user = userssection.data();
    print(" oldin--------------------------------------    $user");
    user!['ishtiroketilganlar'].add(eventId);
    print("keyin------------------------------------------     $user");
    usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update(
      {'ishtiroketilganlar': user['ishtiroketilganlar']},
    );
  }

  Future<void> cancelEvent(String eventId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userssection = await usersCollection.doc(userId).get();
    final user = userssection.data();
    print("ochirihshdan oldin---------------------------------------    $user");
    user!['bekorqilinganlar'].add(eventId);
    user['ishtiroketilganlar'].removeWhere(
      (e) {
        return e == eventId;
      },
    );
    print("ochirihshdan keyin---------------------------------------    $user");
    usersCollection.doc(userId).update(
      {
        'bekorqilinganlar': user['bekorqilinganlar'],
        'ishtiroketilganlar': user['ishtiroketilganlar'],
      },
    );
  }
}
