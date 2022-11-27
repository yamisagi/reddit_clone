import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/login_view/text_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            Constants.logoPath,
            height: 40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  const ClipRRect(
                    child: Image(
                      image: AssetImage(Constants.backgroundPath),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.40,
                        right: 0.0,
                        left: 0.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: Constants.cardRadius,
                        color: ColorPallete.whiteColor,
                        elevation: 4.0,
                        child: Column(
                          children: [
                            const StaticTexts(),
                            Padding(
                              padding: Constants.textFieldPadding,
                              child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorPallete.redColor),
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorPallete.blackColor),
                                    focusedBorder: Constants.outlineInputBorder,
                                    enabledBorder:
                                        Constants.outlineInputBorder),
                              ),
                            ),
                            Padding(
                              padding: Constants.textFieldPadding,
                              child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorPallete.redColor),
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorPallete.greyColor),
                                    focusedBorder: Constants.outlineInputBorder,
                                    enabledBorder:
                                        Constants.outlineInputBorder),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
