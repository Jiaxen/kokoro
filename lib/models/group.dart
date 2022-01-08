import 'package:flutter/foundation.dart';

class Group extends ChangeNotifier{
  final String groupId;
  String groupName;
  List<String> members;
  List<String> invitedMembers;
  DateTime createdTime;

  /// Instantiates a [Group].
  Group({
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.invitedMembers,
    required this.createdTime,
  });

  /// Serializes this [Group] into a JSON object.
  Map<String, dynamic> toJson() => {
    'groupName': groupName,
    'memberNames': members,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

}