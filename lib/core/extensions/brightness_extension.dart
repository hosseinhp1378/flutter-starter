import 'package:flutter/material.dart';

extension BrightnessSid on Brightness {
  Color get contrast => isLight ? Colors.black : Colors.white;

  bool get isLight => this == Brightness.light;
  bool get isDark => !isLight;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}
