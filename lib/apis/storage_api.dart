import 'dart:io';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_x/constants/constants.dart';
import 'package:demo_x/core/provider.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageLinks.add(
        uploadedImage.$id, //AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }

    return imageLinks;
  }

  Future<Uint8List> getImage(String link) async {
    Uint8List result;
    result = await _storage.getFilePreview(
        bucketId: AppwriteConstants.imagesBucket, fileId: link);
    return result;
  }
}
