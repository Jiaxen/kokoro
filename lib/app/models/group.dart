import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Group extends ChangeNotifier{
  String? groupId;
  String? groupName;
  List<String> members;
  List<String>? invitedMembers;
  DateTime? createdTime;

  /// Instantiates a [Group].
  Group({
    this.groupId,
    this.groupName,
    required this.members,
    this.invitedMembers,
    this.createdTime,
  });

  static Group initial = Group(
    groupId: null,
    members: []
  );

  bool isInitial(){
    return groupId == null;
  }

  /// Serializes this [Group] into a JSON object.
  Map<String, dynamic> toMap() => {
    'groupName': groupName,
    'members': members,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

  factory Group.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for GroupId: $documentId');
    }
    return Group(groupId: documentId,
      groupName: data.containsKey('groupName') ? data['groupName'] : '',
      members: List<String>.from(data['members']),
      invitedMembers: data.containsKey('invitedMembers')
          ? List<String>.from(data['invitedMembers'])
          : [],
      createdTime: (data['createdTime'] as Timestamp).toDate(),
    );
  }
}
