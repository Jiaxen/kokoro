import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/models/group.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/screens/find_partner_screen.dart';
import 'package:provider/provider.dart';

class GroupManagementCard extends StatelessWidget {
  const GroupManagementCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Group group = Provider.of<Group>(context);
    return SliverToBoxAdapter(
      child: Container(
        color: kPrimaryAppColour,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: group.invitedMembers == null ? NewPartnerWidget() : NextMeetingWidget(),
        ),
      ),
    );
  }
}

class NewPartnerWidget extends StatelessWidget {
  const NewPartnerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(FindPartnerScreen.id),
      child: Card(
        margin: EdgeInsets.zero,
        color: kSecondaryAppColour,
        child: ListTile(
          leading: Icon(
            Icons.favorite_rounded,
            size: 30,
            color: Colors.amber[100],
          ),
          title: Text(Provider.of<AppUser>(context).currentGroup ?? 'Nope (AU)',
              style: TextStyle(color: kPrimaryTitleColour)),
          subtitle: Text(Provider.of<Group>(context).groupId ?? 'Nope (GP)'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}


class NextMeetingWidget extends StatelessWidget {
  const NextMeetingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(FindPartnerScreen.id),
      child: Card(
        margin: EdgeInsets.zero,
        color: kSecondaryAppColour,
        child: ListTile(
          leading: Icon(
            Icons.event,
            size: 56,
            color: Colors.amber[100],
          ),
          title: Text('Next meeting in 3 days',
              style: TextStyle(color: kPrimaryTitleColour)),
          subtitle: Text('Monday 31st Feb @5.30pm',
              style: TextStyle(color: kPrimaryTitleColour)),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}