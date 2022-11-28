import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/providers/text_editing_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/login_view/login_textfield.dart';
import 'package:reddit_clone/util/login_view/sign_in_button.dart';
import 'package:reddit_clone/util/login_view/text_widget.dart';

final globalKeyProvider =
    Provider<GlobalKey<ScaffoldState>>((ref) => GlobalKey<ScaffoldState>());

class LoginView extends ConsumerWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = ref.watch(globalKeyProvider);
    final emailTextEditing = ref.watch(emailTextEditingProvider.notifier);
    final passwordTextEditing = ref.watch(passwordTextEditingProvider.notifier);
    final isLoading = ref.watch(authControllProvider);
    final scaffoldMessengerKey = ref.watch(scaffoldMessengerKeyProvider);
    return Scaffold(
      key: scaffoldMessengerKey,
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
            onPressed: () {
              ref.read(authControllProvider.notifier).signOut();
            },
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Stack(
                      children: [
                        Image(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          image: const AssetImage(Constants.backgroundPath),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.28,
                            right: 0.0,
                            left: 0.0,
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: Constants.cardRadius,
                              color: ColorPallete.whiteColor,
                              child: Column(
                                children: [
                                  const StaticTexts(),
                                  LoginTextField(
                                    controller: emailTextEditing,
                                    label: 'Enter your email',
                                  ),
                                  LoginTextField(
                                    controller: passwordTextEditing,
                                    label: 'Enter your password',
                                  ),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      return SignInButton(
                                          label: 'Sign In',
                                          onPressed: () async {
                                            await ref
                                                .read(authControllProvider
                                                    .notifier)
                                                .signInWithEmailAndPassword(
                                                  context,
                                                  emailTextEditing.text,
                                                  passwordTextEditing.text,
                                                );
                                            // emailTextEditing.clear();
                                            // passwordTextEditing.clear();
                                          },
                                          top: 0.85,
                                          bottom: 0.15);
                                    },
                                  ),
                                  SignInButton(
                                      key: globalKey,
                                      label: 'Sign Up',
                                      onPressed: () async {
                                        await ref
                                            .read(authControllProvider.notifier)
                                            .signUpWithEmailAndPassword(
                                              context,
                                              emailTextEditing.text,
                                              passwordTextEditing.text,
                                            );

                                        // emailTextEditing.clear();
                                        // passwordTextEditing.clear();
                                      },
                                      top: 0.95,
                                      bottom: 0.05),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
