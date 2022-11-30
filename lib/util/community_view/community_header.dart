import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/models/community_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Align(
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.1,
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
                  ? OutlinedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: Constants.buttonPadding,
                      ),
                      onPressed: () {
                        navigateToModTools(context, community.communityName);
                      },
                      icon: const Icon(Icons.more_horiz),
                      label: const Text("Moderate"),
                    )
                  : OutlinedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: Constants.buttonPadding,
                      ),
                      onPressed: () {},
                      icon: Icon(isMember ? Icons.check_circle : Icons.add),
                      label: Text(isMember ? "Joined" : 'Join'),
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
