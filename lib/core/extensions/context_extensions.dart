import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:starter/core/extensions/navigation_extension.dart';


extension BaseContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  EdgeInsets get safe => mediaQuery.padding;
  ScaffoldState get scaffold => Scaffold.of(this);
  NavigatorState get navigator => Navigator.of(this);

  void unfocus() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      currentScope.unfocus();
    }
  }

  Future<T?> pushPage<T>(Widget page) => navigator.push<T>(MaterialPageRoute<T>(
        builder: (context) {
          return page;
        },
      ));
  Future<void> pushReplacementPage(Widget page) =>
      navigator.pushReplacement(MaterialPageRoute<void>(
        builder: (context) {
          return page;
        },
      ));
  Future<void> showDialog(
    Widget dialog, {
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) =>
      mat.showDialog(
        context: this,
        builder: (_) => dialog,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
      );

}
