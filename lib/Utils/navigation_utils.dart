import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils {
  static navigate(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => widget),
    );
  }

  static removeCurrentAndNavigate(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => widget),
          (route) => false,
    );
  }

  static removeCurrentPage(BuildContext context, widget) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => widget),
    );
  }

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
}