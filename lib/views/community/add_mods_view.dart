// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModsView extends ConsumerStatefulWidget {
  final String communityName;
  const AddModsView({
    super.key,
    required this.communityName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsViewState();
}

class _AddModsViewState extends ConsumerState<AddModsView> {
  Set<String> uidList = {};
  int modCount = 0;

  void addUid(String uid) {
    uidList.add(uid);
    setState(() {});
  }

  void removeUid(String uid) {
    uidList.remove(uid);
    setState(() {});
  }

  Future<void> addMod() async {
    await ref.read(communityControllerProvider.notifier).addModerator(
        communityName: widget.communityName,
        uid: uidList.toList(),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: addMod,
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
            data: (community) {
              return ListView.builder(
                itemCount: community.communityMembers.length,
                itemBuilder: (context, index) {
                  final communityMember = community.communityMembers[index];

                  return ref.watch(getUserDataProvider(communityMember)).when(
                        error: (error, stack) => Center(
                          child: Text(error.toString()),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        data: (user) {
                          community.communityModerators
                                      .contains(communityMember) &&
                                  modCount == 0
                              ? {
                                  uidList.add(communityMember),
                                  modCount++,
                                }
                              : {modCount = modCount};
                          return ListTile(
                            leading: CircleAvatar(
                              radius: kIsWeb
                                  ? MediaQuery.of(context).size.height * 0.02
                                  : MediaQuery.of(context).size.width * 0.05,
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                            title: Text(user.name),
                            trailing: Checkbox(
                              value: uidList.contains(user.uid),
                              onChanged: (value) {
                                if (value!) {
                                  addUid(user.uid);
                                } else {
                                  removeUid(user.uid);
                                }
                              },
                            ),
                          );
                        },
                      );
                },
              );
            },
          ),
    );
  }
}
