import 'package:demo_x/constants/constants.dart';
import 'package:demo_x/features/home/group_view.dart';
import 'package:demo_x/features/home/test_view.dart';
import 'package:demo_x/features/meeting/view/meeting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_x/common/loading_view.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/user_profile/view/user_profile_view.dart';
import 'package:demo_x/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                AssetsConstants.meetingIcon,
                color: Pallete.whiteColor,
                width: 30,
              ),
              title: const Text(
                'Meeting',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MeetingView.route(),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                AssetsConstants.testIcon,
                width: 35,
                color: Pallete.whiteColor,
              ),
              title: const Text(
                'Test',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  TestView.route(),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                AssetsConstants.groupIcon,
                color: Pallete.whiteColor,
                width: 30,
              ),
              title: const Text(
                'Group',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  GroupView.route(),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
