import 'package:flutter/material.dart';

class ShadowsHelper {
  static BoxShadow get sh1 => getBoxShadow(b: 1, s: 1);
  static BoxShadow get sh2 => getBoxShadow(b: 2, s: 3);
  //
  static BoxShadow getBoxShadow({
    Offset? o,
    required double b,
    required double s,
  }) {
    return BoxShadow(
      //color: ,
      offset: o ?? const Offset(0, 2),
      blurRadius: b,
      spreadRadius: s,
    );
  }
}
