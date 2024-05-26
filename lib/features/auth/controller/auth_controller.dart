import 'package:demo_x/apis/auth_api.dart';
import 'package:appwrite/models.dart' as models;
import 'package:demo_x/apis/user_api.dart';
import 'package:demo_x/core/restart_widget.dart';
import 'package:demo_x/core/ultils.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

//get method from all api
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    return AuthController(
      authAPI: ref.watch(authAPIProvider),
      userAPI: ref.watch(userAPIProvider),
    );
  },
);

//get current user provider
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

//get arbitrary user details
final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

//get current user details
final currentUserDetailProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // bool indicate if app is loading

  Future<models.User?> currentUser() {
    final res = _authAPI.currentUserAccount();
    return res;
  }

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          uid: r.$id,
          email: email,
          name: getNameFromEmail(email),
          profilePic: 'https://i.imgur.com/i4WIZ7v.jpg',
          bannerPic: 'https://i.imgur.com/DifWZms.jpg',
          bio: '',
          followers: const [],
          following: const [],
          isBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) {
          showSnackBar(context, l.message);
        }, (r) {
          showSnackBar(context, 'Account created! please login.');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login/', (route) => false);
        });
      },
    );
  } //logout

  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.logIn(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        RestartWidget.restartApp(context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home/', (route) => false);
      },
    );
  } //login

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushNamedAndRemoveUntil(context, '/login/', (_) => false);
    });
  }
}
