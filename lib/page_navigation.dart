import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

class CheckartisanNavigator {
  static Future<String?> push(context, page) {
    return Navigator.push(
        context,
        PageTransition(
            duration: const Duration(milliseconds: 1000),
            type: PageTransitionType.rightToLeftWithFade,
            child: page));
  }

  static Future<String?> pushReplacement(context, page) {
    return Navigator.pushReplacement(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 1000),
          type: PageTransitionType.rightToLeftWithFade,
          child: page,
        ));
  }
}
