import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_x/apis/user_api.dart';
import 'package:demo_x/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(
    userAPI: ref.watch(userAPIProvider),
  );
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

final getFollowingUserProvider =
    FutureProvider.family((ref, List<String> followingList) {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.getFollowingUser(followingList);
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }

  Future<List<UserModel>> getFollowingUser(List<String> followingList) async {
    List<UserModel> result = List.empty(growable: true);
    for (String id in followingList) {
      var document = await _userAPI.getUserByID(id);
      UserModel user = UserModel.fromMap(document.data);
      result.add(user);
    }
    return result;
  }
}
