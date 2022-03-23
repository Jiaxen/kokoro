import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Room extends ChangeNotifier{
  String? roomId;
  String? roomName;
  List<String> members;
  List<String>? invitedMembers;
  DateTime? createdTime;

  /// Instantiates a [Room].
  Room({
    this.roomId,
    this.roomName,
    required this.members,
    this.invitedMembers,
    this.createdTime,
  });

  // Initial value when loading or when error
  static Room initial = Room(
    roomId: 'initial',
    members: []
  );

  bool isInitial(){
    return roomId == 'initial';
  }

  // If user is just created, they have no room
  static Room noRoom = Room(
    roomId: null,
    members: []
  );

  bool isNoRoom(){
    return roomId == null;
  }

  /// Serializes this [Room] into a JSON object.
  Map<String, dynamic> toMap() => {
    'roomName': roomName,
    'members': members,
    'invitedMembers': invitedMembers,
    'createdTime': createdTime,
  };

  factory Room.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for RoomId: $documentId');
    }
    return Room(roomId: documentId,
      roomName: data.containsKey('roomName') ? data['roomName'] : '',
      members: List<String>.from(data['members']),
      invitedMembers: data.containsKey('invitedMembers')
          ? List<String>.from(data['invitedMembers'])
          : [],
      createdTime: (data['createdTime'] as Timestamp).toDate(),
    );
  }
}

