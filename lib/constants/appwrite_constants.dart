class AppwriteConstants {
  static const String projectId = '64cf7162618c8b1a4266';
  static const String databaseId = '64cf76c3a893af5ec2bc';
  static const String endPoint =
      'http://192.168.1.209:80/v1'; //'http://10.0.2.2/v1';

  static const String userCollectionId = '64fb6a80c7400e2a34de';
  static const String postCollection = '65048bdf1957b8b91f75';
  static const String notificationsCollection = '';

  static const String imagesBucket = '65049b71b43a87ba1f7e';

  static String imageUrl(String imageId) =>
      'http://localhost/v1/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
