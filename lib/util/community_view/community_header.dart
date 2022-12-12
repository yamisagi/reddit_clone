import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:routemaster/routemaster.dart';

class CommunityHeaderWidget extends StatelessWidget {
  final CommunityModel community;
  final bool isModerator;
  final bool isMember;
  const CommunityHeaderWidget({
    Key? key,
    required this.community,
    required this.isModerator,
    required this.isMember,
  }) : super(key: key);

  void navigateToModTools(BuildContext context, String name) {
    Routemaster.of(context).push('/mod_tools/$name');
  }

  void joinCommunityOrLeave(
      BuildContext context, WidgetRef ref, CommunityModel community) async {
    await ref.read(communityControllerProvider.notifier).joinCommunityOrLeave(
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
             radius: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.03
                      : MediaQuery.of(context).size.width * 0.05,
              backgroundImage: NetworkImage(
                community.communityAvatar,
              ),
              backgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "r/${community.communityName}",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              isModerator
                  ? Consumer(
                      builder: (context, ref, child) => OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: Constants.buttonPadding,
                          side: BorderSide(
                            color: ref
                                        .watch(themeNotifierProvider.notifier)
                                        .themeMode ==
                                    ThemeMode.dark
                                ? ColorPallete.whiteColor
                                : ColorPallete.blackColor,
                          ),
                        ),
                        onPressed: () {
                          navigateToModTools(context, community.communityName);
                        },
                        icon: const Icon(Icons.more_horiz),
                        label: const Text("Moderate"),
                      ),
                    )
                  : Consumer(
                      builder: (context, ref, child) {
                        return OutlinedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: Constants.buttonPadding,
                            side: BorderSide(
                              color: ref
                                          .watch(themeNotifierProvider.notifier)
                                          .themeMode ==
                                      ThemeMode.dark
                                  ? ColorPallete.whiteColor
                                  : ColorPallete.blackColor,
                            ),
                          ),
                          onPressed: () {
                            joinCommunityOrLeave(context, ref, community);
                          },
                          icon: Icon(
                            isMember
                                ? Icons.remove_circle //
                                : Icons.add,
                          ),
                          label: Text(isMember ? "Joined" : 'Join'),
                        );
                      },
                    ),
            ],
          ),
          const Padding(padding: Constants.smallPadding),
          Text(
            '${community.communityMembers.length} members',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
