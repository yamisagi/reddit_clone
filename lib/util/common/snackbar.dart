import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Key key) {
  ScaffoldMessenger.of(context)
  
    ..showSnackBar(SnackBar(
      key: key,
      content: Text(message),
    ));
}
