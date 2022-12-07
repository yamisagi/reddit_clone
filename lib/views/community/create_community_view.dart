import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/common/loading_widget.dart';

class CreateCommunityView extends ConsumerStatefulWidget {
  const CreateCommunityView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityViewState();
}

class _CreateCommunityViewState extends ConsumerState<CreateCommunityView> {
  late final TextEditingController _communityNameController;
  @override
  void initState() {
    super.initState();
    _communityNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          _communityNameController.text.replaceAll(' ', '').toLowerCase(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      key: ref.read(scaffoldMessengerKeyProvider),
      appBar: AppBar(
        title: const Text('Create Community'),
      ),
      body: isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(Constants.communityName),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  TextField(
                    controller: _communityNameController,
                    decoration: InputDecoration(
                      hintText: Constants.communityNameHint,
                      filled: true,
                      fillColor:
                          ref.read(themeNotifierProvider.notifier).themeMode ==
                                  ThemeMode.dark
                              ? ColorPallete.greyColor
                              : ColorPallete.lightGreyColor,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                    maxLength: 21,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: Constants.buttonStyle,
                      textStyle: Theme.of(context).textTheme.button?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                      minimumSize: Size(
                        double.infinity,
                        MediaQuery.of(context).size.height * 0.06,
                      ),
                    ),
                    onPressed: () {
                      createCommunity();
                    },
                    child: const Text(Constants.createCommunity),
                  )
                ],
              ),
            ),
    );
  }
}
