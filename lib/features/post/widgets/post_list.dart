import 'package:demo_x/features/post/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_x/common/error_page.dart';
import 'package:demo_x/common/loading_view.dart';
import 'package:demo_x/constants/appwrite_constants.dart';
import 'package:demo_x/features/post/controller/post_controller.dart';
import 'package:demo_x/models/post_model.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.create',
                    )) {
                      Post insertedPost = Post.fromMap(data.payload);
                      if (insertedPost.repliedTo == '') {
                        posts.insert(0, insertedPost);
                      }
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postCollection}.documents.*.update',
                    )) {
                      // get id of original post
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final postId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var post =
                          posts.where((element) => element.id == postId).first;

                      final postIndex = posts.indexOf(post);
                      posts.removeWhere((element) => element.id == postId);

                      post = Post.fromMap(data.payload);
                      posts.insert(postIndex, post);
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
