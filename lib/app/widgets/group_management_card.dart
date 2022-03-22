import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/routing/app_router.dart';


class GroupManagementCard extends ConsumerWidget {
  const GroupManagementCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsyncValue = ref.watch(groupProvider);
    return groupAsyncValue.when(
      data: (group) => SliverToBoxAdapter(
        child: Container(
          color: kPrimaryAppColour,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: group.invitedMembers == null ? NewPartnerWidget() : NextMeetingWidget(),
          ),
        ),
      ),
      loading: () => SliverToBoxAdapter(child: Container()),
      error: (_,__) => SliverToBoxAdapter(child: Container()),
    );
  }
}

class NewPartnerWidget extends ConsumerWidget {
  const NewPartnerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value!;
    final group = ref.watch(groupProvider).value!;
    return InkWell(
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.findPartnerScreen),
      child: Card(
        margin: EdgeInsets.zero,
        color: kSecondaryAppColour,
        child: ListTile(
          leading: Icon(
            Icons.favorite_rounded,
            size: 30,
            color: Colors.amber[100],
          ),
          title: Text(user.currentGroup ?? 'Nope (AU)',
              style: TextStyle(color: kPrimaryTitleColour)),
          subtitle: Text(group.groupId ?? 'Nope (GP)'),
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
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.findPartnerScreen),
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