import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/models/note.dart';
import 'package:kokoro/utils.dart';

/// Transforms the Firestore query [snapshot] into a list of [Note] instances.
List<Note> fromQueryToNotes(QuerySnapshot snapshot) => snapshot.toNotes();


/// Add [Note] related methods to [QuerySnapshot].
extension NoteQuery on QuerySnapshot {
  /// Transforms the query result into a list of notes.
  List<Note> toNotes() => docs
      .map((d) => d.toNote())
      .toList();
}


/// Add [Note] related methods to [DocumentSnapshot].
extension NoteDocument on DocumentSnapshot {
  /// Transforms the query result into a list of [Note]s.
  Note toNote() => Note(
    id: id,
    content: get('content'),
    noteState: enumFromString(NoteState.values, get('noteState')) ?? NoteState.current,
    noteType: enumFromString(NoteType.values, get('noteType')) ?? NoteType.appreciation ,
    createdTime: (get('createdTime') as Timestamp).toDate(),
    sentBy: get('sentBy'),
    groupId: get('groupId'),
    meetingId: get('meetingId'),
    lastModifiedTime: (get('lastModifiedTime') as Timestamp).toDate(),
  );
}

/// Returns reference to collection for users.
CollectionReference NotesCollection(String groupId) =>
    FirebaseFirestore.instance
    .collection('group')
    .doc(groupId)
    .collection('notes');