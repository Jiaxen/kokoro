import 'package:flutter/material.dart';

class Note extends ChangeNotifier {
  final String? id;
  String content;
  NoteState noteState;
  NoteType noteType;
  String? meetingId;
  String groupId;
  String sentBy;
  DateTime createdTime;
  DateTime lastModifiedTime;

  Note({
    this.id,
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
  Map<String, dynamic> toJson() => {
    'content': content,
    'noteState': noteState,
    'noteType': noteType,
    'meetingId': meetingId,
    'groupId': groupId,
    'sentBy': sentBy,
    'createdTime': createdTime,
    'lastModifiedTime': lastModifiedTime,
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
