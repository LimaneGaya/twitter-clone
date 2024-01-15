import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/providers.dart';

final storageAPIProvider = Provider(
  (ref) => StorageAPI(storage: ref.watch(appwriteStorageProvider)),
);

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      try {
        final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path),
        );
        imageLinks.add(
            'https://cloud.appwrite.io/v1/storage/buckets/${AppwriteConstants.imagesBucket}/files/${uploadedImage.$id}/view?project=${AppwriteConstants.projectId}');
      } catch (e) {
        throw Exception(e);
      }
    }
    return imageLinks;
  }

  Future<Uint8List> getImage(String id) async {
    return await _storage.getFilePreview(
      bucketId: AppwriteConstants.imagesBucket,
      fileId: id,
      quality: 90,
      output: 'jpg',
      height: 400,
    );
  }

  Future<void> deleteAllFiles() async {
    final files = await _storage.listFiles(
      bucketId: AppwriteConstants.imagesBucket,
      queries: [
        Query.limit(50),
      ],
    );
    for (var file in files.files) {
      await _storage.deleteFile(
          bucketId: AppwriteConstants.imagesBucket, fileId: file.$id);
    }
  }
}
