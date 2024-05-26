import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_x/common/error_page.dart';
import 'package:demo_x/common/loading_view.dart';
import 'package:demo_x/constants/constants.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/post/widgets/post_card.dart';
import 'package:demo_x/features/user_profile/controller/user_profile_controller.dart';
import 'package:demo_x/features/user_profile/view/edit_profile_view.dart';
import 'package:demo_x/features/user_profile/widget/follow_count.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:demo_x/theme/pallete.dart';

class UserProfile extends ConsumerStatefulWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  bool? isFollowing = false;

  @override
  Widget build(BuildContext context) {
    UserModel user = widget.user;
    final currentUser = ref.watch(currentUserDetailProvider).value;
    isFollowing = currentUser?.following.contains(user.uid);
    return (currentUser == null)
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.blueColor,
                              )
                            //TODO: fix this
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          //TODO: fix this
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              // edit profile
                              Navigator.push(context, EditProfileView.route());
                            } else {
                              ref
                                  .read(userProfileControllerProvider.notifier)
                                  .followUser(
                                    user: user,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                              setState(() {
                                isFollowing = !isFollowing!;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Pallete.whiteColor,
                                  width: 1.0,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              backgroundColor: Pallete.blueColor),
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : isFollowing!
                                    ? 'Unfollow'
                                    : 'Follow',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Divider(color: Pallete.whiteColor),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserPostsProvider(user.uid)).when(
                  data: (posts) {
                    int i = 0;
                    while (i < posts.length) {
                      if (posts[i].repliedTo != '') {
                        posts.removeAt(i);
                      } else {
                        i++;
                      }
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
