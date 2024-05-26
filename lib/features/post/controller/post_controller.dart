import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:demo_x/apis/post_api.dart';
import 'package:demo_x/core/enum/post_enum.dart';
import 'package:demo_x/core/ultils.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/models/post_model.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
    );
  },
);

final getPostsProvider = FutureProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getRepliesToPostsProvider = FutureProvider.family((ref, Post post) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getRepliesToPost(post);
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

final getPostByIdProvider = FutureProvider.family((ref, String id) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

final getPostsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostsByHashtag(hashtag);
});

final getCommentCountProvider = FutureProvider.family((ref, Post post) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getCommentCount(post);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  //TODO: impliment notification
  //final NotificationController _notificationController;
  final Ref _ref;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
  })  : _ref = ref,
        _postAPI = postAPI,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<Post> getPostById(String id) async {
    final post = await _postAPI.getPostById(id);
    return Post.fromMap(post.data);
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;

    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes);
    final res = await _postAPI.likePost(post);
    res.fold((l) => null, (r) {
      // _notificationController.createNotification(
      //   text: '${user.name} liked your post!',
      //   postId: post.id,
      //   notificationType: NotificationType.like,
      //   uid: post.uid,
      // );
      //TODO: impliment notification
    });
  }

  void resharePost(
    Post post,
    UserModel currentUser,
    BuildContext context,
  ) async {
    post = post.copyWith(
      repostedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: post.reshareCount + 1,
    );

    final res = await _postAPI.updateReshareCount(post);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        post = post.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          postedAt: DateTime.now(),
        );
        final res2 = await _postAPI.sharePost(post);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            // _notificationController.createNotification(
            //   text: '${currentUser.name} reshared your post!',
            //   postId: post.id,
            //   notificationType: NotificationType.repost,
            //   uid: post.uid,
            // );
            //TODO: impliment noti
            showSnackBar(context, 'Reposted!');
          },
        );
      },
    );
  }

  Future<List<Post>> getRepliesToPost(Post post) async {
    final documents = await _postAPI.getRepliesToPost(post);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<int> getCommentCount(Post post) async {
    final document = await _postAPI.getRepliesToPost(post);
    return document.length;
  }

  Future<List<Post>> getPostsByHashtag(String hashtag) async {
    final documents = await _postAPI.getPostByHashtag(hashtag);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter content for your post!');
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
        image: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextBasePost(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
      if (repliedTo != '') {
        Post post = await getPostById(repliedTo);
        post = post.copyWith(commentCount: post.commentCount + 1);
        _postAPI.updateCommentCount(post);
      }
    }
  }

  void _shareImagePost({
    required List<File> image,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {}

  void _shareTextBasePost({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text: text);
    String link = _getLinkFromText(text: text);
    final user = _ref.read(currentUserDetailProvider).value!;
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      repostedBy: '',
      repliedTo: repliedTo,
      commentCount: 0,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      // if (repliedToUserId.isNotEmpty) {
      //   _notificationController.createNotification(
      //     text: '${user.name} replied to your post!',
      //     postId: r.$id,
      //     notificationType: NotificationType.reply,
      //     uid: repliedToUserId,
      //   );
      // }
    });
    state = false;
  }

  String _getLinkFromText({
    required String text,
  }) {
    String link = '';
    List<String> wordInSentence = text.split(' ');
    for (String word in wordInSentence) {
      if (word.startsWith('www.') || word.startsWith('https://')) {
        link = word;
      }
    }
    return link;
  } //get link from text

  List<String> _getHashtagsFromText({required String text}) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  } //get hashtags from text
}
