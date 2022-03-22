import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.title = 'Loading...',
    this.message = '',
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryAppColour,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(alignment: Alignment.center,
              image: AssetImage('images/HeartManDoodle.png'), height: 170,),
            SizedBox(height: 10),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 32.0, color: Colors.white),
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
