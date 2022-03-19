import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/utils.dart';


class Note extends ChangeNotifier {
  String? id;
  String content;
  NoteState noteState;
  NoteType noteType;
  String? meetingId;
  String groupId;
  String sentBy;
  DateTime createdTime;
  DateTime lastModifiedTime;

  Note({
    required this.id,
    required this.content,
    required this.noteState,
    required this.noteType,
    this.meetingId,
    required this.groupId,
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
    'groupId': groupId,
    'sentBy': sentBy,
    'createdTime': Timestamp.fromDate(createdTime),
    'lastModifiedTime': Timestamp.fromDate(lastModifiedTime),
  };

  /// Update this [Note] with specified properties.
  ///
  /// If [updateTimestamp] is `true`, which is the default,
  /// `modifiedAt` will be updated to `DateTime.now()`.
  Note updateWith({
    String? content,
    NoteState? noteState,
    NoteType? noteType,
    String? meetingId,
    String? groupId,
    bool updateTimestamp = true,
  }) {
    if (content != null) this.content = content;
    if (noteState != null) this.noteState = noteState;
    if (noteType != null) this.noteType = noteType;
    if (meetingId != null) this.meetingId = meetingId;
    if (groupId != null) this.groupId = groupId;
    if (updateTimestamp) lastModifiedTime = DateTime.now();
    notifyListeners();
    return this;
  }

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
      groupId: data['groupId'],
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
