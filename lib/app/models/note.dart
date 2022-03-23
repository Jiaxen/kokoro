import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/utils.dart';


class Note extends ChangeNotifier {
  String? id;
  String content;
  NoteState noteState;
  NoteType noteType;
  String? meetingId;
  String roomId;
  String sentBy;
  DateTime createdTime;
  DateTime lastModifiedTime;

  Note({
    required this.id,
    required this.content,
    required this.noteState,
    required this.noteType,
    this.meetingId,
    required this.roomId,
    required this.sentBy,
    required this.createdTime,
    required this.lastModifiedTime,
  });

  /// Serializes this [Note] into a JSON object.
  Map<String, dynamic> toMap() => {
    'content': content,
    'noteState': enumToString(noteState),
    'noteType': enumToString(noteType),
    'meetingId': meetingId,
    'roomId': roomId,
    'sentBy': sentBy,
    'createdTime': Timestamp.fromDate(createdTime),
    'lastModifiedTime': Timestamp.fromDate(lastModifiedTime),
  };

  factory Note.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for NoteId: $documentId');
    }
    return Note(id: documentId,
      content: data['content'],
      noteState: enumFromString(NoteState.values, data['noteState']) ?? NoteState.current,
      noteType: enumFromString(NoteType.values, data['noteType']) ?? NoteType.appreciation ,
      createdTime: (data['createdTime'] as Timestamp).toDate(),
      sentBy: data['sentBy'],
      roomId: data['roomId'],
      meetingId: data['meetingId'],
      lastModifiedTime: (data['lastModifiedTime'] as Timestamp).toDate(),
    );
  }
}

enum NoteType {
  appreciation,
  chores,
  plans,
  challenges,
}

enum NoteState {
  archive,
  current,
  past,
}

List<String> noteTypes = enumToCapitalisedList(NoteType.values);
