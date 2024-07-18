import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  double lat;
  double lng;
  String firstname;
  String lastname;
  String email;
  String imageUrl;
  List isFavoriteEvents;
  List<String> tashkiletilganlar;
  List<String> ishtiroketilganlar;
  List<String> bekorqilinganlar;
  List<String> yaqinda;

  UserModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.imageUrl,
    required this.tashkiletilganlar,
    required this.ishtiroketilganlar,
    required this.bekorqilinganlar,
    required this.yaqinda,
    required this.isFavoriteEvents,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      lat: data['lat'],
      lng: data['lng'],
      firstname: data['firstname'],
      lastname: data['lastname'],
      email: data['email'],
      imageUrl: data['imageUrl'],
      tashkiletilganlar: List<String>.from(data['tashkiletilganlar']),
      ishtiroketilganlar: List<String>.from(data['ishtiroketilganlar']),
      bekorqilinganlar: List<String>.from(data['bekorqilinganlar']),
      yaqinda: List<String>.from(data['yaqinda']),
      isFavoriteEvents: data['isFavoriteEvents'],
    );
  }
}
