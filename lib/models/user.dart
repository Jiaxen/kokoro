import 'package:firebase_auth/firebase_auth.dart';

/// Naming this class AppUser to differentiate from firebase's [User] class
class AppUser {
  final String uid;
  String? email;
  String? displayName;
  String? photoURL;
  String? currentGroup;

  AppUser(
      {required this.uid,
      this.email,
      this.displayName,
      this.photoURL,
      this.currentGroup});

  Map<String, dynamic> appUserToJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'currentGroup': currentGroup
    };
  }
}
