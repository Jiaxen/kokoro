import 'dart:async';

import 'package:kokoro/app/models/group.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/services/firestore_path.dart';
import 'package:kokoro/services/firestore_service.dart';


class FirestoreDatabase {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setUser(AppUser appUser) =>
      _service.updateData(
        documentPath: FirestorePath.user(uid),
        data: appUser.toMap(),
      );

  Stream<AppUser> appUserStream() {
    return _service.documentStream(
      path: FirestorePath.user(uid),
      builder: (data, documentId) => AppUser.fromMap(data, documentId),
    );
  }

  Stream<Group> groupStream({required String groupId}) => _service.documentStream(
    path: FirestorePath.group(groupId),
    builder: (data, documentId) => Group.fromMap(data, documentId),
  );

  Future<void> setGroup(Group group) {
    if (group.groupId != null){
      // Update note in Firebase
      return _service.updateData(
        documentPath: FirestorePath.group(group.groupId!),
        data: group.toMap(),
      );
    }else{
      // Create note in Firebase if note.id is null
      return _service.addData(
        collectionPath: FirestorePath.groups(),
        data: group.toMap(),
      );
    }
  }

  Stream<Note> noteStream({required String noteId, required String groupId}) => _service.documentStream(
        path: FirestorePath.note(groupId, noteId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Stream<List<Note>> notesStream({required String groupId}) => _service.collectionStream(
        path: FirestorePath.notes(groupId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Future<void> setNote(Note note) {
    if (note.id != null){
      // Update note in Firebase
      return _service.updateData(
        documentPath: FirestorePath.note(note.groupId, note.id!),
        data: note.toMap(),
      );
    }else{
      // Create note in Firebase if note.id is null
      return _service.addData(
        collectionPath: FirestorePath.notes(note.groupId),
        data: note.toMap(),
      );
 }
  }

  Future<void> deleteNote(Note note) =>
      _service.deleteData(path: FirestorePath.note(uid, note.id!));

}
