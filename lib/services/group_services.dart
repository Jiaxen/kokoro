import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/models/group.dart';

Group documentSnapshotToGroup(DocumentSnapshot documentSnapshot) {
  return Group(
      groupId: documentSnapshot.id,
      groupName: documentSnapshot.get('groupName'),
      members: List<String>.from(documentSnapshot.get('members')),
      invitedMembers: List<String>.from(documentSnapshot.get('invitedMembers')),
      createdTime: (documentSnapshot.get('createdTime') as Timestamp).toDate(),);
}


Future<dynamic> saveGroupToFireStore(Group group) async {
  final groupCol = groupCollection();
  Map<String, dynamic> groupAsJson = group.groupToJson();
  group.groupId == null ? groupCol.add(groupAsJson) : groupCol.doc(group.groupId).set(groupAsJson, SetOptions(merge: true));
}


/// Returns reference to collection for groups.
CollectionReference groupCollection() =>
    FirebaseFirestore.instance.collection('group');