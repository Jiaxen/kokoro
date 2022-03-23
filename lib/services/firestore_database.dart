import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/app/models/room.dart';
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

  Stream<List<Room>> invitedRoomStream(AppUser appUser){
        //  Look for rooms to which a user has been invited
      return _service.collectionStream(
          path: FirestorePath.rooms(),
          builder: (data, documentId) => Room.fromMap(data, documentId),
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

  Stream<Room> roomStream({required String roomId}) =>
      // Stream room information
      _service.documentStream(
        path: FirestorePath.room(roomId),
        builder: (data, documentId) => Room.fromMap(data, documentId),
      );

  Future<void> setRoom(Room room) {
    // Update room in firestore
    return _service.updateData(
      documentPath: FirestorePath.room(room.roomId!),
      data: room.toMap(),
    );
  }

  Future<DocumentReference> addRoom(Room room) {
    // Create new room in firestore
    return _service.addData(
      collectionPath: FirestorePath.rooms(),
      data: room.toMap(),
    );
  }

  Stream<Note> noteStream({required String noteId, required String roomId}) =>
      // Stream info about a particular note
      _service.documentStream(
        path: FirestorePath.note(roomId, noteId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Stream<List<Note>> notesStream({required String roomId}) =>
      // Stream all notes of a given room
      _service.collectionStream(
        path: FirestorePath.notes(roomId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Future<void> setNote(Note note) {
    // Update or create a Note
    if (note.id != null) {
      // Update note in Firebase
      return _service.updateData(
        documentPath: FirestorePath.note(note.roomId, note.id!),
        data: note.toMap(),
      );
    } else {
      // Create note in Firebase if note.id is null
      return _service.addData(
        collectionPath: FirestorePath.notes(note.roomId),
        data: note.toMap(),
      );
    }
  }

  Future<void> deleteNote(Note note) =>
      _service.deleteData(path: FirestorePath.note(note.roomId, note.id!));
}
