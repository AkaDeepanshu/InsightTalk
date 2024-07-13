// theme.dart
import 'package:flutter/material.dart';
import 'package:insighttalk_expert/themes/text_form_field_widget.dart';

final ThemeData appTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2C98F0)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
  inputDecorationTheme: TTextFieldFormTheme.lightInputDecorationTheme,
  useMaterial3: false,
);