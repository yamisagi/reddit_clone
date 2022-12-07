import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/views/core/login_view.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.isEmail,
  }) : super(key: key);
  final TextEditingController controller;
  final String label;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final globalKey = ref.watch(globalKeyProvider);
        return Padding(
          padding: Constants.textFieldPadding,
          child: TextField(
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : TextInputType.visiblePassword,
            obscureText: isEmail ? false : true,
            onTap: () {
              // Fix for keyboard overlapping the text field
              Future.delayed(const Duration(milliseconds: 530), () {
                Scrollable.ensureVisible(
                  globalKey.currentContext!,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            },
            controller: controller,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: ColorPallete.redColor),
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorPallete.greyColor.withOpacity(0.8)),
                focusedBorder: Constants.outlineInputBorder,
                enabledBorder: Constants.outlineInputBorder),
          ),
        );
      },
    );
  }
}
