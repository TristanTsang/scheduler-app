import 'dart:ui';

import 'package:flutter/material.dart';
// Color Palletes //
const Color kLightGrey = Color(0xffD0D0D0);
const Color kDarkGrey = Color(0xff696969);
const Color kGrey = Color(0xff909090);
const Color backgroundColor = Color(0xffededed);

//App Theme//
Color kPrimaryColor = Color(0xff000000);
Color kAccentColor = kGrey;
Color kLightAccentColor = kLightGrey;
Color kDeepAccentColor = kDarkGrey;

//Font Sizes//
double largeFontSize =22.5;
double smallishLargeFontSize = 20;
double defaultFontSize = 17.5;
double smallFontSize =15;


//Text Styles//
TextStyle primaryHeader = TextStyle(fontSize: largeFontSize, fontWeight: FontWeight.bold, color: kPrimaryColor);
TextStyle primarySubtitle = TextStyle(color: kDeepAccentColor, fontSize: smallishLargeFontSize,);

TextStyle secondaryHeader = TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold, color: kPrimaryColor);
TextStyle secondarySubtitle = TextStyle(color: kAccentColor, fontSize: defaultFontSize);

TextStyle tertiaryHeader = TextStyle(color: kPrimaryColor, fontSize: defaultFontSize, fontWeight: FontWeight.bold);

TextStyle defaultStyle = TextStyle(fontSize: defaultFontSize);
TextStyle colorDefaultStyle = TextStyle(color: kPrimaryColor, fontSize: defaultFontSize);
