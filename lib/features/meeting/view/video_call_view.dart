import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/meeting/api/jitsi_api.dart';
import 'package:demo_x/features/meeting/widget/meeting_option.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:demo_x/theme/pallete.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoCallView extends ConsumerStatefulWidget {
  const VideoCallView({super.key});

  @override
  ConsumerState<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends ConsumerState<VideoCallView> {
  final JitsiMethods _jitsiMethods = JitsiMethods();
  late TextEditingController idController;
  late TextEditingController nameController;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  _joinMeeting(UserModel currentUser) {
    _jitsiMethods.createNewMeeting(
      roomName: idController.text,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      currentUser: currentUser,
    );
  }

  onAudioMuted(bool val) {
    setState(() {
      isAudioMuted = val;
    });
  }

  onVideoMuted(bool val) {
    setState(() {
      isVideoMuted = val;
    });
  }

  @override
  void initState() {
    idController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    String name = ((currentUser == null) ? '' : currentUser.name);
    nameController.text = name;
    return currentUser == null
        ? const LoadingPage()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Pallete.backgroundGreyColor,
              title: const Text(
                'Join a meeting',
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: idController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      fillColor: Pallete.backgroundGreyColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Enter room ID',
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: nameController,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      fillColor: Pallete.backgroundGreyColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => _joinMeeting(currentUser),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Pallete.backgroundGreyColor,
                        border: Border.all(
                          width: 0,
                          color: Pallete.backgroundColor,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Text(
                        'Join',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                MeetingOption(
                  text: "Mute audio",
                  isMuted: isAudioMuted,
                  onChange: onAudioMuted,
                ),
                MeetingOption(
                  text: "Turn off video",
                  isMuted: isVideoMuted,
                  onChange: onVideoMuted,
                )
              ],
            ),
          );
  }
}
