import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class UserDrawer extends ConsumerWidget {
  const UserDrawer({super.key});

  void signOut(BuildContext context, WidgetRef ref) async {
    ref.read(authControllProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: MediaQuery.of(context).size.width * 0.15,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              'u/${user.name}',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => null,
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: ColorPallete.redColor,
              ),
              onTap: () => signOut(context, ref),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.light_mode,
                  color: ColorPallete.lightModeAppTheme.backgroundColor,
                ),
                Switch.adaptive(
                  value: true,
                  onChanged: (val) => null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
