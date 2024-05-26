import 'package:demo_x/models/user_model.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class JitsiMethods {
  void createNewMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    required UserModel currentUser,
    String userName = '',
  }) async {
    try {
      String name;
      if (userName.isEmpty) {
        name = currentUser.name;
      } else {
        name = userName;
      }
      var options = JitsiMeetingOptions(
          serverUrl: 'https://vroom.truevirtualworld.com/',
          //alternative:
          //vroom.truevirtualworld.com
          //jitsi.hivane.net
          //jitsi.dorf-post.de
          //jitsi.milkywan.fr
          roomNameOrUrl: roomName,
          userDisplayName: name,
          userEmail: currentUser.email,
          userAvatarUrl: currentUser.profilePic,
          isAudioMuted: isAudioMuted,
          isVideoMuted: isVideoMuted);

      await JitsiMeetWrapper.joinMeeting(options: options);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
