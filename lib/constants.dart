import 'package:flutter/material.dart';
import 'dart:ui';


// Colours
Color kPrimaryAppColour = const Color(0xFF615896);
Color kSecondaryAppColour = const Color(0xFF827BAC);
Color kErrorTextColorLight = const Color(0xFFBF4545);
Color kPrimaryTitleColour = Colors.white;
Color kPrimaryTextColour = Colors.black;
Color kPrimaryBackgroundColour = Colors.white;
Color kSecondaryBackgroundColour = const Color(0xFFAAAAAA);


//Device Height
var pixelRatio = window.devicePixelRatio;

//Size in physical pixels
var physicalScreenSize = window.physicalSize;

//Size in logical pixels
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalHeight = logicalScreenSize.height;

//Padding in physical pixels
var padding = window.padding;
var paddingTop = window.padding.top / window.devicePixelRatio;
var paddingBottom = window.padding.bottom / window.devicePixelRatio;

var safeHeight = logicalHeight - paddingTop - paddingBottom;