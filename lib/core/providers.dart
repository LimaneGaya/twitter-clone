import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';

final appwriteClientProvider = Provider((ref) => Client()
    .setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId));

final appwriteAccountProvider =
    Provider((ref) => Account(ref.watch(appwriteClientProvider)));

final appwriteDatabaseProvider =
    Provider((ref) => Databases(ref.watch(appwriteClientProvider)));

final appwriteStorageProvider =
    Provider((ref) => Storage(ref.watch(appwriteClientProvider)));

final appwriteRealtimeProvider =
    Provider((ref) => Realtime(ref.watch(appwriteClientProvider)));
