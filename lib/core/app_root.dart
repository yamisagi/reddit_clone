import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/router.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/common/error_widget.dart';
import 'package:routemaster/routemaster.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  UserModel? _userModel;

  void _init(WidgetRef ref, User data) async {
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
              theme: ref.watch(themeNotifierProvider),
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
                  } else {
                    //Else navigate to login page
                    return signedOutRoute;
                  }
                  // When user refreshes the page and user data is not fetched yet from the database
                  // Show loading widget until user data is fetched.
                  //! This is to avoid showing login page when user is already logged in
                  return loadingRoute;
                },
              ),
              routeInformationParser: const RoutemasterParser(),
            );
          }),
          error: ((error, stackTrace) => ErrorText(
                errorText: error.toString(),
              )),
          loading: (() => const Center(
                child: CircularProgressIndicator(),
              )),
        );
  }
}
