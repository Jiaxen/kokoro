import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kokoro/models/group.dart';
import 'package:kokoro/models/user.dart';
import 'package:provider/provider.dart';

Group documentSnapshotToGroup(DocumentSnapshot doc) {
  if (doc.data() == null) {
    return Group.initial;
  }
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return Group(
    groupId: doc.id,
    groupName: data.containsKey('groupName') ? doc.get('groupName') : '',
    members: List<String>.from(doc.get('members')),
    invitedMembers: data.containsKey('invitedMembers')
        ? List<String>.from(doc.get('invitedMembers'))
        : [],
    createdTime: (doc.get('createdTime') as Timestamp).toDate(),
  );
}

Future<dynamic> saveGroupToFireStore(Group group) async {
  final groupCol = groupCollection();
  Map<String, dynamic> groupAsJson = group.groupToJson();
  group.groupId == null
      ? groupCol.add(groupAsJson)
      : groupCol.doc(group.groupId).set(groupAsJson, SetOptions(merge: true));
}

/// Returns reference to collection for groups.
CollectionReference groupCollection() =>
    FirebaseFirestore.instance.collection('group');

DocumentReference groupDocument(groupName) => groupCollection().doc(groupName);