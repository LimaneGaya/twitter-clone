import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_clone/theme/theme.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchBarStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: const BorderSide(
      color: Pallete.searchBarColor,
      width: 2,
    ),
  );
  final searchTextContr = TextEditingController();
  bool search = false;
  @override
  void dispose() {
    searchTextContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onEditingComplete: () {
              search = true;
              setState(() {});
            },
            controller: searchTextContr,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: searchBarStyle,
              focusedBorder: searchBarStyle,
              hintText: 'Search Twitter',
            ),
          ),
        ),
      ),
      body: search
          ? ref.watch(searchUserProvider(searchTextContr.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, idx) {
                      final user = users[idx];
                      return SearchTile(userModer: user);
                    },
                  );
                },
                error: (er, st) => ErrorText(error: er.toString()),
                loading: () => const Loader(),
              )
          : const SizedBox(),
    );
  }
}
