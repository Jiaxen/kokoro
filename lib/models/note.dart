import 'package:flutter/material.dart';

class Note extends ChangeNotifier {
  final String? id;
  String content;
  NoteType noteType;
  NoteState noteState;
  String meetingId;
  String groupId;
  String sentBy;
  DateTime createdTime;
  DateTime lastModifiedTime;

  Note({
    this.id,
    required this.content,
    required this.noteType,
    required this.noteState,
    required this.meetingId,
    required this.groupId,
    required this.sentBy,
    required this.createdTime,
    required this.lastModifiedTime,
  });

  /// Serializes this note into a JSON object.
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
}

enum NoteType {
  appreciation,
  chores,
  plans,
  challenges,
}
enum NoteState {
  current,
  past,
}
