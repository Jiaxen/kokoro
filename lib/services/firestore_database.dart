import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/app/models/group.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/services/firestore_path.dart';
import 'package:kokoro/services/firestore_service.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Future<void> updateUserFirebaseDetails(AppUser appUser) =>
      // Update 'user' firestore collection with latest firebase details
      _service.updateData(
        documentPath: FirestorePath.user(uid),
        data: appUser.firebaseDetailsToMap(),
        merge: true,
      );

  Future<void> setUser(AppUser appUser) => _service.updateData(
        // Update user firestore collection
        documentPath: FirestorePath.user(uid),
        data: appUser.toMap(),
        merge: true,
      );

  Stream<List<Group>> invitedGroupStream(AppUser appUser){
        //  Look for groups to which a user has been invited
      return _service.collectionStream(
          path: FirestorePath.groups(),
          builder: (data, documentId) => Group.fromMap(data, documentId),
          queryBuilder: (query) => query.where('invitedMembers',
              arrayContains: appUser.email!.toLowerCase())
      );
  }
  
  Stream<AppUser> appUserStream() {
    // Stream user information
    return _service.documentStream(
      path: FirestorePath.user(uid),
      builder: (data, documentId) => AppUser.fromMap(data, documentId),
    );
  }

  Stream<Group> groupStream({required String groupId}) =>
      // Stream group information
      _service.documentStream(
        path: FirestorePath.group(groupId),
        builder: (data, documentId) => Group.fromMap(data, documentId),
      );

  Future<void> setGroup(Group group) {
    // Update group in firestore
    return _service.updateData(
      documentPath: FirestorePath.group(group.groupId!),
      data: group.toMap(),
    );
  }

  Future<DocumentReference> addGroup(Group group) {
    // Create new group in firestore
    return _service.addData(
      collectionPath: FirestorePath.groups(),
      data: group.toMap(),
    );
  }

  Stream<Note> noteStream({required String noteId, required String groupId}) =>
      // Stream info about a particular note
      _service.documentStream(
        path: FirestorePath.note(groupId, noteId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Stream<List<Note>> notesStream({required String groupId}) =>
      // Stream all notes of a given group
      _service.collectionStream(
        path: FirestorePath.notes(groupId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Future<void> setNote(Note note) {
    // Update or create a Note
    if (note.id != null) {
      // Update note in Firebase
      return _service.updateData(
        documentPath: FirestorePath.note(note.groupId, note.id!),
        data: note.toMap(),
      );
    } else {
      // Create note in Firebase if note.id is null
      return _service.addData(
        collectionPath: FirestorePath.notes(note.groupId),
        data: note.toMap(),
      );
    }
  }

  Future<void> deleteNote(Note note) =>
      _service.deleteData(path: FirestorePath.note(note.groupId, note.id!));
}
