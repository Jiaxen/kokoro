import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/models/group.dart';

Group documentSnapshotToGroup(DocumentSnapshot documentSnapshot) {
  return Group(
      groupId: documentSnapshot.id,
      groupName: documentSnapshot.get('groupName'),
      members: documentSnapshot.get('members'),
      invitedMembers: documentSnapshot.get('invitedMembers'),
      createdTime: documentSnapshot.get('createdTime'));
}


Future<dynamic> saveGroupToFireStore(Group group) async {
  final groupCol = groupCollection();
  Map<String, dynamic> groupAsJson = group.groupToJson();
  group.groupId == null ? groupCol.add(groupAsJson) : groupCol.doc(group.groupId).set(groupAsJson, SetOptions(merge: true));
}


/// Returns reference to collection for groups.
CollectionReference groupCollection() =>
    FirebaseFirestore.instance.collection('group');