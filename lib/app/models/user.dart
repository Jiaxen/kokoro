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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'currentGroup': currentGroup
    };
  }


  factory AppUser.fromMap(Map<String, dynamic>? data, String uid) {
    if (data == null) {
      throw StateError('missing data for uid: $uid');
    }
    return AppUser(uid: uid,
          email: data['email'],
          photoURL: data['photoURL'],
          displayName: data['displayName'],
          currentGroup: data['currentGroup'],
    );
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
