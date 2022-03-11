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

  Future<void> setUser(AppUser appUser) => _service.setData(
        path: FirestorePath.user(uid),
        data: appUser.toMap(),
      );

  // Future<void> deleteUser(AppUser appUser) async {
  //   // delete where entry.jobId == job.jobId
  //   final allEntries = await entriesStream(job: job).first;
  //   for (final entry in allEntries) {
  //     if (entry.jobId == job.id) {
  //       await deleteEntry(entry);
  //     }
  //   }
  //   // delete job
  //   await _service.deleteData(path: FirestorePath.job(uid, job.id));
  // }

  Stream<Group> GroupStream({required String groupId}) => _service.documentStream(
    path: FirestorePath.group(groupId),
    builder: (data, documentId) => Group.fromMap(data, documentId),
  );

  Stream<Note> NoteStream({required String noteId}) => _service.documentStream(
        path: FirestorePath.note(uid, noteId),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Stream<List<Note>> NotesStream() => _service.collectionStream(
        path: FirestorePath.notes(uid),
        builder: (data, documentId) => Note.fromMap(data, documentId),
      );

  Future<void> setNote(Note note) => _service.setData(
        path: FirestorePath.note(note.groupId, note.id),
        data: note.toMap(),
      );

  Future<void> deleteNote(Note note) =>
      _service.deleteData(path: FirestorePath.note(uid, note.id));

}
