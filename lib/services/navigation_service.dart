import 'package:flutter/material.dart';
import 'package:nothing_notes/main.dart';

class NavigationService {
  static Future<void> defaultPopUpDialog(String title,
      [String message = ""]) async {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"))
          ],
        ),
      );
    }
  }

  static Future<void> navigateTo(String routeName) async {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static Future<void> navigateBackTo() async {
    navigatorKey.currentState?.pop();
  }

  static Future<void> navigateAndRemoveUntil(String routeName) async {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}
