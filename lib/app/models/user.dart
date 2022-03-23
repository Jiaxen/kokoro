import 'package:firebase_auth/firebase_auth.dart';

/// Naming this class AppUser to differentiate from firebase's [User] class
class AppUser {
  final String uid;
  String? email;
  String? displayName;
  String? photoURL;
  String? currentRoom;

  AppUser(
      {required this.uid,
      this.email,
      this.displayName,
      this.photoURL,
      this.currentRoom});

  static AppUser initial = AppUser(
      uid: '',
      email: null,
      displayName: null,
      photoURL: null,
      currentRoom: null);

  bool isInitial(){
    return uid == '' ? true : false;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'currentRoom': currentRoom
    };
  }

  Map<String, dynamic> firebaseDetailsToMap() {
    // This is the same as toMap, but only for merging new firebase details
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
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
          currentRoom: data['currentRoom'],
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
