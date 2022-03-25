import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/routing/app_router.dart';


class RoomManagementCard extends ConsumerWidget {
  const RoomManagementCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsyncValue = ref.watch(roomProvider);
    return roomAsyncValue.when(
      data: (room) => SliverToBoxAdapter(
        child: Container(
          color: kPrimaryAppColour,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: NextMeetingWidget(),
          ),
        ),
      ),
      loading: () => SliverToBoxAdapter(child: Container()),
      error: (_,__) => SliverToBoxAdapter(child: Container()),
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
          title: Text('Meeting feature in development',
              style: TextStyle(color: kPrimaryTitleColour)),
          subtitle: Text('Check back soon!',
              style: TextStyle(color: kPrimaryTitleColour)),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}