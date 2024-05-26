import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:demo_x/constants/constants.dart';
import 'package:demo_x/core/core.dart';
import 'package:demo_x/core/provider.dart';
import 'package:demo_x/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

//provider
final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

//abstract
abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
  Future<model.Document> getUserByID(String id);
}

//implements
class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some thing unexpected happen',
          st,
        ),
      );
    } catch (e, st) {
      return left(
        Failure(
          e.toString(),
          st,
        ),
      );
    }
  }

  @override
  Future<model.Document> getUserData(String uid) async {
    final res = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollectionId,
      documentId: uid,
    );

    return res;
  }

  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: user.uid,
        data: {
          'following': user.following,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.userCollectionId}.documents'
    ]).stream;
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollectionId,
      queries: [
        Query.search('name', name),
      ],
    );
    return documents.documents;
  }

  @override
  Future<model.Document> getUserByID(String id) async {
    final documment = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userCollectionId,
      documentId: id,
    );
    return documment;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      print('call to user api');
      print('user model: $userModel');
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      print('got to exception: ${e.type}');
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      print('got to exception 2');
      return left(Failure(e.toString(), st));
    }
  }
}
