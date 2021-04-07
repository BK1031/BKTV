import 'package:flutter/material.dart';

final mainColor = Color(0xFF2db1ff);
final altColor = Color(0xFFb03a26);

const lightTextColor = Colors.black;
const lightBackgroundColor = Color(0xFFf9f9f9);
const lightCardColor = Colors.white;
const lightDividerColor = const Color(0xFFC9C9C9);

// DARK THEME
const darkTextColor = Colors.white;
const darkBackgroundColor = const Color(0xFF212121);
const darkCardColor = const Color(0xFF2C2C2C);
const darkDividerColor = const Color(0xFF616161);

// CURRENT COLORs
var currTextColor = darkTextColor;
var currBackgroundColor = darkBackgroundColor;
var currCardColor = darkCardColor;
var currDividerColor = darkDividerColor;

ThemeData mainTheme = new ThemeData(
  accentColor: mainColor,
  primaryColor: mainColor,
  fontFamily: "DIN Condensed",
  brightness: Brightness.dark
);