import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokoro/app/models/room.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      expect(
              () => Room.fromMap(null, 'abc'), throwsA(isInstanceOf<StateError>()));
    });
    test('room with all properties', () {
      final room = Room.fromMap({
        'roomName': 'Test Room Name',
        'members': ['user1', 'user2'],
        'invitedMembers': ['user3@example.com'],
        'createdTime': Timestamp.fromMicrosecondsSinceEpoch(1522129071),
      }, 'abc');
      expect(room.toMap(), Room(roomId: 'abc', roomName: 'Test Room Name', members: ['user1', 'user2'], invitedMembers: ['user3@example.com'], createdTime: DateTime.fromMicrosecondsSinceEpoch(1522129071)).toMap());
    });

    test('missing members', () {
      expect(
              () => Room.fromMap(const {
                'roomName': 'Test Room Name',
                'invitedMembers': ['user3@example.com'],
                'createdTime': 1522129071 ,
          }, 'abc'),
          throwsA(isInstanceOf<StateError>()));
    });
  });
}
