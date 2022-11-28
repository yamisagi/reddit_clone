import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({Key? key, required this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(errorText),
      ),
    );
  }
}
