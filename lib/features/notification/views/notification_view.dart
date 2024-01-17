import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/features/notification/widgets/notification_tile.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/models/notification_model.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDetailsProvider).value;
    return user == null
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Notifications'),
            ),
            body: ref.watch(getNotificationsProvider(user.uid)).when(
                data: (notifs) {
                  return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create')) {
                          final notif = NotificationModel.fromMap(data.payload);
                          if (notif.uid == user.uid) {
                            notifs.insert(0, notif);
                          }
                        }
                        return ListView.builder(
                          itemBuilder: ((BuildContext context, int index) {
                            final notif = notifs[index];
                            return NotificationTile(notification: notif);
                          }),
                          itemCount: notifs.length,
                        );
                      },
                      error: ((error, stackTrace) =>
                          ErrorText(error: error.toString())),
                      loading: () {
                        return ListView.builder(
                          itemBuilder: ((BuildContext context, int index) {
                            final notif = notifs[index];
                            return NotificationTile(notification: notif);
                          }),
                          itemCount: notifs.length,
                        );
                      });
                },
                error: ((error, stackTrace) =>
                    ErrorText(error: error.toString())),
                loading: () => const Loader()));
  }
}
