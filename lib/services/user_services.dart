import 'package:firebase_auth/firebase_auth.dart';
import 'package:kokoro/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

AppUser documentSnapshotToAppUser(DocumentSnapshot documentSnapshot) {
  return AppUser(
          uid: documentSnapshot.id,
          email: documentSnapshot.get('email'),
          photoURL: documentSnapshot.get('photoURL'),
          displayName: documentSnapshot.get('displayName'),
          currentGroup: documentSnapshot.get('currentGroup'));
}

Future<dynamic> saveUserToFireStore(AppUser appUser) async {
  final userCol = userCollection();
  Map<String, dynamic> userAsJson = appUser.appUserToJson();
  userCol.doc(appUser.uid).set(userAsJson, SetOptions(merge: true));
}

void saveFirebaseUserToFirestore(User firebaseUser) {
  // Create AppUser from Firebase User
  AppUser appUser = AppUser(
    uid: firebaseUser.uid,
    email: firebaseUser.email,
    displayName: firebaseUser.displayName,
    photoURL: firebaseUser.photoURL,
  );
  // Save AppUser to firestore
  saveUserToFireStore(appUser);
}

/// Returns reference to collection for users.
CollectionReference userCollection() =>
    FirebaseFirestore.instance.collection('users');
