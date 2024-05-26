// ignore_for_file: deprecated_member_use

import 'package:demo_x/constants/assest_constants.dart';
import 'package:demo_x/features/explore/view/following_view.dart';
import 'package:demo_x/features/home/side_drawer.dart';
import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:demo_x/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final appBar = UIConstants.appBar();
  int _page = 0;
  List<Widget> bottomBarPage = UIConstants.bottomTabBarPages;
  void onPageChange(int index) {
    setState(() {
      bottomBarPage.removeAt(2);
      bottomBarPage.insert(2, FollowingView(key: UniqueKey()));
      _page = index;
    });
  }

  void onCreatePost() {
    Navigator.of(context).pushNamed('/new-post/');
  }

  // void onLogOut() {
  //   final authController = authControllerProvider;
  //   ref.read(authController.notifier).logout(context);
  // }

  @override
  Widget build(BuildContext context) {
    UIConstants.appBar();
    return Scaffold(
      appBar: (_page == 5) ? null : appBar,
      body: IndexedStack(
        index: _page,
        children: bottomBarPage,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreatePost,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      drawer: const SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Pallete.whiteColor,
        unselectedItemColor: Pallete.greyColor,
        currentIndex: _page,
        backgroundColor: Pallete.backgroundColor,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          onPageChange(value);
        },
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AssetsConstants.homeFilledIcon,
                color: Pallete.greyColor,
              ),
              activeIcon: SvgPicture.asset(
                AssetsConstants.homeFilledIcon,
                color: Pallete.blueColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.greyColor,
              ),
              activeIcon: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.blueColor,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                AssetsConstants.friendsIcon,
                color: Pallete.greyColor,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                AssetsConstants.friendsIcon,
                color: Pallete.blueColor,
                width: 25,
              ),
              label: ''),
        ],
      ),
    );
  }
}
