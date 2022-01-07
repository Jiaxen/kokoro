import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Naming this class AppUser to differentiate from firebase's User class
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

  void saveAppUserToFirestore(User firebaseUser) {
    AppUser appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
    appUser.saveUserToFireStore(profile: appUser.appUserToJson());
  }

  Future<dynamic> saveUserToFireStore({Map<String, dynamic>? profile}) async {
    final userCol = userCollection();
    profile == null
        ? userCol.doc(uid).set({})
        : userCol.doc(uid).set(profile, SetOptions(merge: true));
  }

  /// Returns reference to collection for users.
  CollectionReference userCollection() =>
      FirebaseFirestore.instance.collection('users');
}
