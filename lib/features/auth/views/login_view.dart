import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/login_view/sign_in_button.dart';
import 'package:reddit_clone/util/login_view/text_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
          child: Center(
            child: Image.asset(
              Constants.logoPath,
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Continue as Guest',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: ColorPallete.redColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  const Image(
                    image: AssetImage(Constants.backgroundPath),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.40,
                      right: 0.0,
                      left: 0.0,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: Constants.cardRadius,
                        color: ColorPallete.whiteColor,
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
                                    labelText: 'Enter your email',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorPallete.greyColor
                                            .withOpacity(0.8)),
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
                                    labelText: 'Enter your Password',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorPallete.greyColor
                                            .withOpacity(0.8)),
                                    focusedBorder: Constants.outlineInputBorder,
                                    enabledBorder:
                                        Constants.outlineInputBorder),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SignInButton(
                      label: 'Sign In',
                      onPressed: () {},
                      top: 0.85,
                      bottom: 0.15),
                  SignInButton(
                      label: 'Sign Up',
                      onPressed: () {},
                      top: 0.95,
                      bottom: 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
