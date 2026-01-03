import 'package:flutter/widgets.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isSmallDevice(BuildContext context) => width(context) < 360;

  static bool isLargeDevice(BuildContext context) => width(context) > 420;
  // 🔥 ADD THIS
  static double scale(BuildContext context) {
    final w = width(context);
    if (w < 360) return 0.85;
    if (w > 420) return 1.1;
    return 1.0;
  }
}
