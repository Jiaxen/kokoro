import 'package:flutter/foundation.dart';

class Group extends ChangeNotifier{
  final String groupId;
  String groupName;
  List<String> memberNames;
  List<String> invitedMembers;
  DateTime createdTime;

  /// Instantiates a [Group].
  Group({
    required this.groupId,
    required this.groupName,
    required this.memberNames,
    required this.invitedMembers,
    required this.createdTime,
  });

  /// Serializes this [Group] into a JSON object.
  Map<String, dynamic> toJson() => {
    'groupName': groupName,
    'memberNames': memberNames,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

}