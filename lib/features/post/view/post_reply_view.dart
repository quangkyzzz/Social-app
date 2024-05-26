import 'package:demo_x/constants/assest_constants.dart';
import 'package:demo_x/features/post/widgets/comment_card.dart';
import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_x/common/common.dart';
import 'package:demo_x/constants/appwrite_constants.dart';
import 'package:demo_x/features/post/controller/post_controller.dart';
import 'package:demo_x/features/post/widgets/post_card.dart';
import 'package:demo_x/models/post_model.dart';
import 'package:flutter_svg/svg.dart';

class PostReplyScreen extends ConsumerWidget {
  static route(Post post) => MaterialPageRoute(
        builder: (context) => PostReplyScreen(
          post: post,
        ),
      );
  final Post post;
  const PostReplyScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController replyController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          PostCard(
            post: post,
            thickNess: 2,
            dividerColor: Pallete.blueColor,
          ),
          ref.watch(getRepliesToPostsProvider(post)).when(
                data: (posts) {
                  return ref.watch(getLatestPostProvider).when(
                        data: (data) {
                          final latestPost = Post.fromMap(data.payload);

                          bool isPostAlreadyPresent = false;
                          for (final postModel in posts) {
                            if (postModel.id == latestPost.id) {
                              isPostAlreadyPresent = true;
                              break;
                            }
                          }

                          if (!isPostAlreadyPresent &&
                              latestPost.repliedTo == post.id) {
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.create',
                            )) {
                              posts.insert(0, Post.fromMap(data.payload));
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.update',
                            )) {
                              // get id of original post
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endPoint =
                                  data.events[0].lastIndexOf('.update');
                              final postId = data.events[0]
                                  .substring(startingPoint + 10, endPoint);

                              var post = posts
                                  .where((element) => element.id == postId)
                                  .first;

                              final postIndex = posts.indexOf(post);
                              posts.removeWhere(
                                  (element) => element.id == postId);

                              post = Post.fromMap(data.payload);
                              posts.insert(postIndex, post);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return CommentCard(post: post);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return CommentCard(post: post);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 150,
            ),
            child: TextField(
              controller: replyController,
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Your reply',
                hintStyle: const TextStyle(fontSize: 22),
                suffixIcon: InkWell(
                  child: SvgPicture.asset(
                    AssetsConstants.sendIcon,
                    color: Pallete.greyColor,
                    height: 5,
                    width: 5,
                  ),
                  onTap: () {
                    ref.read(postControllerProvider.notifier).sharePost(
                      images: [],
                      text: replyController.text,
                      context: context,
                      repliedTo: post.id,
                      repliedToUserId: post.uid,
                    );
                    replyController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  } //widget buil
}//class
