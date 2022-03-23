import 'package:flutter/material.dart';
import 'dart:ui';


// Colours
Color kPrimaryAppColour = const Color(0xFF7266B1);
Color kSecondaryAppColour = const Color(0xFF837BB4);
Color kErrorTextColorLight = const Color(0xFFBF4545);
Color kWarningBackgroundColorLight = const Color(0xFFFA7A7A);
Color kPrimaryTitleColour = Colors.white;
Color kPrimaryTextColour = const Color(0xFF433C69);
Color kPrimaryBackgroundColour = Colors.white;
Color kSecondaryBackgroundColour = const Color(0xFFAAAAAA);
Color kTextBackgroundColour = const Color(0xFFF3F3F3);

ButtonStyle roundButtonStyle(Color foregroundColour, Color backgroundColour) {
  return ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.all(15)),
    backgroundColor: MaterialStateProperty.all<Color>(backgroundColour),
    foregroundColor: MaterialStateProperty.all<Color>(foregroundColour),
    shape: MaterialStateProperty.all<OutlinedBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        )),
  );
}


TextStyle mainTitleStyle() {
  return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: kPrimaryTitleColour);
}

Widget roundedTextBox(Widget child){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: roundedBoxDecoration(),
    child: child,
  );
}


BoxDecoration roundedBoxDecoration() {
  return BoxDecoration(
      color: kSecondaryAppColour,
      borderRadius: BorderRadius.all(Radius.circular(12),),);
}