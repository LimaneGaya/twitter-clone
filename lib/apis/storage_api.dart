import 'dart:io';

import 'package:appwrite/appwrite.dart';
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
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: 'unique()',
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(uploadedImage.$id);
    }
    return imageLinks;
  }
}