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
  Map<String, dynamic> groupToJson() => {
    'groupName': groupName,
    'members': members,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

}

