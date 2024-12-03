import 'package:flutter/material.dart';

extension NavigatorExtensions on NavigatorState {
  void popAll({
    Widget? thenAdd,
  }) {
    while (canPop()) {
      pop();
    }
    if (thenAdd case Widget child) {
      pushReplacement(MaterialPageRoute(builder: (context) {
        return child;
      }));
    }
  }

  Future<T?> pushPage<T>(Widget page) => push<T>(MaterialPageRoute<T>(
        builder: (context) {
          return page;
        },
      ));
}