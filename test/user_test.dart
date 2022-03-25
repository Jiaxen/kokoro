import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kokoro/app/models/user.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      expect(
              () => AppUser.fromMap(null, 'abc'), throwsA(isInstanceOf<StateError>()));
    });
    test('room with all properties', () {
      final room = AppUser.fromMap({
        'email': 'blahblah@example.com',
        'photoURL': 'example.com',
        'displayName': 'Doctor Who',
        'currentRoom': 'Tardis room 137'
      }, 'abc');
      expect(room.toMap(), AppUser(uid: 'abc', email: 'blahblah@example.com',
          photoURL: 'example.com',displayName: 'Doctor Who',
          currentRoom: 'Tardis room 137').toMap());
    });
  });
}
