import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/models/user_model.dart';

class UserProfileHeader extends StatelessWidget {
  final UserModel user;
  const UserProfileHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "u/${user.name}",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Padding(padding: Constants.smallPadding),
          Text(
            '${user.karma} Karma',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Padding(padding: Constants.smallPadding),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
