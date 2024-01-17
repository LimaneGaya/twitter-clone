import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/home/widgets/side_drawer.dart';
import 'package:twitter_clone/features/tweet/view/create_tweet_view.dart';
import 'package:twitter_clone/theme/theme.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: ((context) => const HomeView()));

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final AppBar appBar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void onCreateTweetButtonPressed() {
    Navigator.of(context).push(CreateTweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      drawer: const SideDrawer(),
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweetButtonPressed,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onPageChange,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Pallete.backgroundColor,
              label: 'Home',
              icon: SvgPicture.asset(
                _page == 0
                    ? AssetsConstants.homeFilledIcon
                    : AssetsConstants.homeOutlinedIcon,
                colorFilter: const ColorFilter.mode(
                  Pallete.whiteColor,
                  BlendMode.srcIn,
                ),
              )),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              colorFilter: const ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              colorFilter: const ColorFilter.mode(
                Pallete.whiteColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
