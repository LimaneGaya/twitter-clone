class AppwriteConstants {
  static const String databaseId = '6590630f9eeffd6b9085';
  static const String projectId = '6589ed0c8789b37d5e7a';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '6590633a17948c5cb984';
  static const String tweetsCollection = '65980cfc105390fb4f6d';
  static const String notificationsCollection = '63cd5ff88b08e40a11bc';

  static const String imagesBucket = '65982171d0cdc7dc8dc2';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
