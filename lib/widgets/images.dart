import 'package:flutter/material.dart';
import 'package:kokoro/constants.dart';
import 'dart:math' as math;

Row partnersDoodle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: kTextBackgroundColour, shape: BoxShape.circle),
              ),
              SizedBox(height: 40)
            ],
          ),
          Image(image: AssetImage('images/ReadingSideDoodle.png'), height: 120),
        ],
      ),
      Column(
        children: [
          SizedBox(height: 60),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  width: 100,
                  height: 100,
                  color: kTextBackgroundColour,
                ),
              ),
              Image(
                  image: AssetImage('images/SitReadingDoodle.png'),
                  height: 120),
            ],
          ),
        ],
      ),
    ],
  );
}