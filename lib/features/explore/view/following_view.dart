import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/explore/controller/explore_controller.dart';
import 'package:demo_x/features/explore/widgets/search_tile.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:demo_x/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowingView extends ConsumerStatefulWidget {
  const FollowingView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollwingViewState();
}

class _FollwingViewState extends ConsumerState<FollowingView> {
  List<UserModel>? followingUserList = [];
  List<UserModel> displayList = [];
  bool fullDisplay = false;
  final searchController = TextEditingController();

  void updateList(String searchName) {
    setState(() {
      fullDisplay = false;
      if (searchName == '') {
        displayList =
            List.from(followingUserList!); //List.from(followingUserList);
      } else {
        displayList = List.from(
          followingUserList!
              .where((element) =>
                  element.name.toLowerCase().contains(searchName.toLowerCase()))
              .toList(),
        );
      }
    });
  }

  @override
  void initState() {
    fullDisplay = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );

    var currentUser = ref.watch(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const LoadingPage();
    }
    followingUserList =
        ref.watch(getFollowingUserProvider(currentUser.following)).value!;

    ref.invalidate(getFollowingUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (value) => updateList(value),
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search your friend',
            ),
          ),
        ),
      ),
      body: fullDisplay
          ? ListView.builder(
              itemCount: followingUserList!.length,
              itemBuilder: (BuildContext context, index) {
                final followingUser = followingUserList![index];
                return SearchTile(userModel: followingUser);
              },
            )
          : ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (BuildContext context, index) {
                final followingUser = displayList[index];
                return SearchTile(userModel: followingUser);
              },
            ),
    );
  }
}
