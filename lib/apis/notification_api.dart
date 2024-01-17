import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/models/notification_model.dart';

final notificationAPIProvider = Provider(
  (ref) => NotificationAPI(databases: ref.watch(appwriteDatabaseProvider)),
);

abstract class INotificationAPI {
  FutureEither<void> createNotification(NotificationModel notification);
  Future<List<Document>> getNotifications(String uid);
}

class NotificationAPI implements INotificationAPI {
  final Databases _db;
  NotificationAPI({
    required Databases databases,
  }) : _db = databases;
  @override
  FutureEither<void> createNotification(NotificationModel notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Something went wrong', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final lis = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollection,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('\$createdAt'),
      ],
    );
    return lis.documents;
  }
}
