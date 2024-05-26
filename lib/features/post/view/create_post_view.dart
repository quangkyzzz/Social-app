import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/post/controller/post_controller.dart';
import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostView extends ConsumerStatefulWidget {
  const CreatePostView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  final postTextController = TextEditingController();

  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
      images: [],
      text: postTextController.text,
      context: context,
      repliedTo: '',
      repliedToUserId: '',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: sharePost,
            label: 'Post',
            backGroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          )
        ],
      ),
      body: (isLoading) || (currentUser == null)
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.profilePic),
                          radius: 28,
                          backgroundColor: Pallete.whiteColor,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: postTextController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Create your post!",
                              hintStyle: TextStyle(
                                color: Pallete.greyColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
