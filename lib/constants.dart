import 'package:flutter/material.dart';
import 'dart:ui';


// Colours
Color kPrimaryAppColour = const Color(0xFF615896);
Color kSecondaryAppColour = const Color(0xFF827BAC);
Color kErrorTextColorLight = const Color(0xFFBF4545);
Color kWarningBackgroundColorLight = const Color(0xFFFA7A7A);
Color kPrimaryTitleColour = Colors.white;
Color kPrimaryTextColour = Colors.black;
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