import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryAppColour,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '心',
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: kSecondaryAppColour,
                    fontSize: 144,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Kokoro',
                style: TextStyle(
                    color: kPrimaryFontColour,
                    fontSize: 48,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Relationship Meetings',
                style: TextStyle(
                    color: kPrimaryFontColour,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )
            ]),
      ),
    );
  }
}
