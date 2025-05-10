import 'package:flutter/material.dart';

class ScaffoldMessengerWrapper {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _DefaultSnack(message: message),
    );
  }
}

class _DefaultSnack extends SnackBar {
  final String message;

  _DefaultSnack({required this.message}) : super(content: Text(message));
}
