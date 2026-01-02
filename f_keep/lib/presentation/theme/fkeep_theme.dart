import 'package:flutter/material.dart';

const ColorScheme appColor = ColorScheme(
  brightness: Brightness.light,
  //primary color
  primary: Color(0xFF58C663), //main
  onPrimary: Colors.white,  
  primaryContainer: Color(0xFFE9F7EC), //soft
  onPrimaryContainer: Color(0xFF46B154), //dark
  //secondary color
  secondary: Color(0xFFFFA136), //main
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFFF2E3), //soft
  onSecondaryContainer: Color(0xFFE68A1F), //dark
  //status color
  error: Color(0xFFE54B4B),
  onError: Colors.white,
  outline: Color(0xFFEEEEEE), //input/disable
  //suface color
  surface: Colors.white, 
  onSurface: Color(0xFF3D393B), // text/primary
  //surface variants 
  surfaceContainer: Color(0xFFF5F5F5), //input/default
  onSurfaceVariant: Color(0xFF6B6769), //text/secondary 
  
);
