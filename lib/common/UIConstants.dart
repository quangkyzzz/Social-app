import 'package:demo_x/features/explore/view/explore_view.dart';
import 'package:demo_x/features/explore/view/following_view.dart';
import 'package:demo_x/features/post/widgets/post_list.dart';
import 'package:flutter/material.dart';
import 'package:demo_x/theme/theme.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'EduSocial',
        style: TextStyle(color: Pallete.blueColor),
      ),
    );
  }

  static List<Widget> bottomTabBarPages = [
    const PostList(),
    const ExploreView(),
    FollowingView(),
  ];
}
