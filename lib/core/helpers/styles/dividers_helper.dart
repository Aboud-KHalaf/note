import 'package:flutter/material.dart';

class DividerHelper {
  static const double thickness = 0.5;
  static Divider get h1 => const Divider(
        height: 1,
        thickness: thickness,
      );
  static VerticalDivider get v1 => const VerticalDivider(
        width: 1,
        thickness: thickness,
      );
}
