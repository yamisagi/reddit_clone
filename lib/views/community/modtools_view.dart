// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsView extends StatelessWidget {
  final String name;
  const ModToolsView({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit_community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Moderator'),
            onTap: () => Routemaster.of(context).push('/add_mods/$name'),
            leading: const Icon(Icons.add_moderator_outlined),
          ),
          ListTile(
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunity(context),
            leading: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
