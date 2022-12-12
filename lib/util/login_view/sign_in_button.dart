import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.top,
    required this.bottom,
  }) : super(key: key);
  final String label;
  final VoidCallback onPressed;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPallete.redColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
