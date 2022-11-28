import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/router.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/common/error_widget.dart';
import 'package:reddit_clone/util/common/loading_widget.dart';
import 'package:routemaster/routemaster.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  UserModel? _userModel;

  Future<void> _init(WidgetRef ref, User data) async {
    // Get the user data from the database
    _userModel = await ref
        .read(authControllProvider.notifier)
        .getUserData(data.uid)
        .first;
    // Update the user provider
    ref.read(userProvider.notifier).update((state) => _userModel);
    // Update the state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: ((data) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Reddit Clone',
              theme: ColorPallete.darkModeAppTheme,
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) {
                  if (data != null) {
                    // If user is logged in
                    // Init the user data
                    _init(ref, data);
                    if (_userModel != null) {
                      // If user data is not null
                      // Navigate to home page
                      return signedInRoute;
                    }
                  } //Else navigate to login page
                  return signedOutRoute;
                },
              ),
              routeInformationParser: const RoutemasterParser(),
            );
          }),
          error: ((error, stackTrace) => ErrorText(
                errorText: error.toString(),
              )),
          loading: (() => const LoadingWidget()),
        );
  }
}
