import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>(
  (ref) => NotificationController(
      notificationAPI: ref.watch(notificationAPIProvider)),
);
final getNotificationsProvider = FutureProvider.family(
  (ref, String uid) =>
      ref.watch(notificationControllerProvider.notifier).getNotifications(uid),
);

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({
    required NotificationAPI notificationAPI,
  })  : _notificationAPI = notificationAPI,
        super(false);

  Future<void> createNotification({
    required String text,
    required String postID,
    required NotificationType type,
    required String uid,
  }) async {
    final notif = NotificationModel(
      text: text,
      postID: postID,
      id: '',
      uid: uid,
      notificationType: type,
    );
    final res = await _notificationAPI.createNotification(notif);
    res.fold((l) => null, (r) => null);
  }

  Future<List<NotificationModel>> getNotifications(String uid) async {
    final res = await _notificationAPI.getNotifications(uid);
    return res.map((e) => NotificationModel.fromMap(e.data)).toList();
  }
}
