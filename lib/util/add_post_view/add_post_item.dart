import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';

class AddPostItem extends StatelessWidget {
  const AddPostItem({
    Key? key,
    required this.cardHW,
    required this.iconSize,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final double cardHW;
  final double iconSize;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: cardHW,
          height: cardHW,
          child: Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Center(
              child: Icon(
                icon,
                color: ColorPallete.lightGreyColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
