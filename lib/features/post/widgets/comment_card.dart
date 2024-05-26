import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/post/view/post_reply_view.dart';
import 'package:demo_x/features/user_profile/view/user_profile_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:demo_x/constants/assest_constants.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/post/controller/post_controller.dart';
import 'package:demo_x/features/post/widgets/hashtag_text.dart';
import 'package:demo_x/features/post/widgets/post_icon_button.dart';
import 'package:demo_x/models/post_model.dart';
import 'package:demo_x/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends ConsumerWidget {
  final Post post;
  const CommentCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PostReplyScreen.route(post),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  UserProfileView.route(user),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (post.repostedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        color: Pallete.greyColor,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${post.repostedBy} reposted',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@${user.name} . ${timeago.format(
                                        post.postedAt,
                                        locale: 'en_short',
                                      )}',
                                      style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                                if (post.repliedTo.isNotEmpty)
                                  ref
                                      .watch(
                                        getPostByIdProvider(post.repliedTo),
                                      )
                                      .when(
                                        data: (repliedToPost) {
                                          final replyingToUser = ref
                                              .watch(
                                                userDetailsProvider(
                                                  repliedToPost.uid,
                                                ),
                                              )
                                              .value;
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Replying to',
                                              style: const TextStyle(
                                                color: Pallete.greyColor,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      ' @${replyingToUser?.name}',
                                                  style: const TextStyle(
                                                    color: Pallete.blueColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, st) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => const SizedBox(),
                                      ),
                                HashtagText(text: post.text),
                                // if (post.postType == PostType.image)
                                //   CarouselImage(imageLinks: post.imageLinks),
                                if (post.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: 'https://${post.link}',
                                  ),
                                ],
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    right: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      PostIconButton(
                                        pathName: AssetsConstants.commentIcon,
                                        text: post.commentCount.toString(),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PostReplyScreen.route(post),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 15),
                                      LikeButton(
                                        size: 25,
                                        onTap: (isLiked) async {
                                          ref
                                              .read(postControllerProvider
                                                  .notifier)
                                              .likePost(
                                                post,
                                                currentUser,
                                              );
                                          return !isLiked;
                                        },
                                        isLiked: post.likes
                                            .contains(currentUser.uid),
                                        likeBuilder: (isLiked) {
                                          return isLiked
                                              ? SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeFilledIcon,
                                                  color: Pallete.redColor,
                                                )
                                              : SvgPicture.asset(
                                                  AssetsConstants
                                                      .likeOutlinedIcon,
                                                  color: Pallete.greyColor,
                                                );
                                        },
                                        likeCount: post.likes.length,
                                        countBuilder:
                                            (likeCount, isLiked, text) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: isLiked
                                                    ? Pallete.redColor
                                                    : Pallete.whiteColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                const Divider(color: Pallete.greyColor)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}
