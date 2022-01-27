import 'package:flutter/foundation.dart';

class Group extends ChangeNotifier{
  String? groupId;
  String? groupName;
  List<String> members;
  List<String>? invitedMembers;
  DateTime createdTime;

  /// Instantiates a [Group].
  Group({
    this.groupId,
    this.groupName,
    required this.members,
    this.invitedMembers,
    required this.createdTime,
  });

  /// Serializes this [Group] into a JSON object.
  Map<String, dynamic> groupToJson() => {
    'groupName': groupName,
    'members': members,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

}

