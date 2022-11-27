import 'package:flutter/material.dart';

class StaticTexts extends StatelessWidget {
  const StaticTexts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: RichText(
        text: TextSpan(
            text: "The best ",
            style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 42, color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Reddit",
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontSize: 42,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: " experience",
                style: TextStyle(
                    fontSize: 42,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }
}
