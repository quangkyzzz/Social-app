import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/post/widgets/post_card.dart';
import 'package:demo_x/features/user_profile/controller/user_profile_controller.dart';
import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupPostView extends ConsumerStatefulWidget {
  const GroupPostView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const GroupPostView(),
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupPostViewState();
}

class _GroupPostViewState extends ConsumerState<GroupPostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Group Post',
          style: TextStyle(color: Pallete.blueColor),
        ),
      ),
      body: ref.watch(getUserPostsProvider('64fed52d47781faa880d')).when(
            data: (posts) {
              int i = 0;
              while (i < posts.length) {
                if (posts[i].repliedTo != '') {
                  posts.removeAt(i);
                } else {
                  i++;
                }
              }
              // can make it realtime by copying code
              // from twitter_reply_view
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
