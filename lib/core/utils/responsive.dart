import 'package:flutter/widgets.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isSmallDevice(BuildContext context) => width(context) < 360;

  static bool isLargeDevice(BuildContext context) => width(context) > 420;
}
