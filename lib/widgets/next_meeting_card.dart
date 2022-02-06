import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/screens/find_partner_screen.dart';


class NextMeetingCard extends StatelessWidget {
  const NextMeetingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: kPrimaryAppColour,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(FindPartnerScreen.id),
            child: Card(
              margin: EdgeInsets.zero,
              color: kSecondaryAppColour,
              child: ListTile(
                leading:
                Icon(Icons.event, size: 56, color: Colors.amber[100]),
                title: Text('Next meeting in 3 days',
                    style: TextStyle(color: kPrimaryTitleColour)),
                subtitle: Text('Monday 31st Feb @5.30pm',
                    style: TextStyle(color: kPrimaryTitleColour)),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}