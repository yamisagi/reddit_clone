import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate({required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          FocusScope.of(context).unfocus();
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchProvider(query)).when(
      error: (error, stack) {
        return const Center(
          child: Text('Error'),
        );
      },
      loading: () {
        if (query.isEmpty || query.length < 3) {
          return const Center(
            child: Text('Search for a community'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      data: (data) {
        return data.isEmpty &&
                query.isNotEmpty &&
                query.length >
                    2 // We don't want to show suggestions for short queries for cost reasons :)
            ? Center(
                child: Text(
                  'No results found for $query',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      
                      backgroundImage: NetworkImage(
                        data[index].communityAvatar,
                      ),
                    ),
                    title: Text('r/${data[index].communityName}'),
                    onTap: () {
                      Routemaster.of(context)
                          .push('/r/${data[index].communityName}');
                    },
                  );
                },
              );
      },
    );
  }
}
