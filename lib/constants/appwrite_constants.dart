class AppwriteConstants {
  static const String databaseId = '65a83caca6acd187e1d2';
  static const String projectId = '6589ed0c8789b37d5e7a';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '65a83cedcf00f933e9c7';
  static const String tweetsCollection = '65a83d03940df1645071';
  static const String notificationsCollection = '65a83d1120711c909602';

  static const String imagesBucket = '65982171d0cdc7dc8dc2';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
