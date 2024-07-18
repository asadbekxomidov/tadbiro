import 'package:flutter/material.dart';
import 'package:tadbiro/services/user_firestore_services.dart';

class FavoriteUserController extends ChangeNotifier {
  final userFireStoreServices = UsersFirebaseServices();

  Future<void> userslikeEventFavorite(String userId, String eventId) async {
    await userFireStoreServices.userslikeEvent(userId, eventId);
    notifyListeners();
  }

  Future<void> favoriteRemoveUser(String userId, String eventId) async {
    await userFireStoreServices.favoriteRemove(userId, eventId);
    notifyListeners();
  }
}
