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

  static AppUser initial = AppUser(
      uid: '',
      email: null,
      displayName: null,
      photoURL: null,
      currentGroup: null);

  bool isInitial(){
    return uid == '' ? true : false;
  }

  Map<String, dynamic> appUserToJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'currentGroup': currentGroup
    };
  }

  Map<String, dynamic> firebaseDetailsToJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
