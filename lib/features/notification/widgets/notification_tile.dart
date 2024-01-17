import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/models/notification_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });
  Widget? getLeading(NotificationType? type) {
    switch (type) {
      case NotificationType.like:
        return SvgPicture.asset(
          AssetsConstants.likeFilledIcon,
          colorFilter:
              const ColorFilter.mode(Pallete.redColor, BlendMode.srcIn),
          height: 20,
        );
      case NotificationType.follow:
        return const Icon(Icons.person, color: Pallete.blueColor);
      case NotificationType.retweet:
        return SvgPicture.asset(
          AssetsConstants.retweetIcon,
          colorFilter:
              const ColorFilter.mode(Pallete.whiteColor, BlendMode.srcIn),
          height: 20,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getLeading(notification.notificationType),
      title: Text(notification.text),
    );
  }
}
