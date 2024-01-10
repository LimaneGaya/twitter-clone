import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/theme/theme.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchTextContr = TextEditingController();
  @override
  void dispose() {
    searchTextContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBarStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
        width: 2,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
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
    );
  }
}
