import 'dart:math';
import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/meeting/api/jitsi_api.dart';
import 'package:demo_x/features/meeting/widget/meeting_button.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingView extends ConsumerStatefulWidget {
  const MeetingView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const MeetingView(),
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetingViewState();
}

class _MeetingViewState extends ConsumerState<MeetingView> {
  final JitsiMethods _jitsiMethods = JitsiMethods();

  final Random _rnd = Random();

  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void createNewMeeting(UserModel currentUser) async {
    String roomName = (_rnd.nextInt(100000000) + 100000000).toString();
    _jitsiMethods.createNewMeeting(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
      currentUser: currentUser,
    );
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call/');
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    return currentUser == null
        ? const LoadingPage()
        : Scaffold(
            appBar: UIConstants.appBar(),
            body: Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MeetingButton(
                      onPressed: () {
                        return createNewMeeting(currentUser);
                      },
                      icon: Icons.videocam,
                      text: 'New meeting',
                    ),
                    MeetingButton(
                      onPressed: () => joinMeeting(context),
                      icon: Icons.add_box_outlined,
                      text: 'Join meeting',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: Text(
                    'Connect to a meeting',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
