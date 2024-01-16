import 'package:flutter/foundation.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';

@immutable
class NotificationModel {
  final String text;
  final String postID;
  final String id;
  final String uid;
  final NotificationType notificationType;
  const NotificationModel({
    required this.text,
    required this.postID,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  NotificationModel copyWith({
    String? text,
    String? postID,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return NotificationModel(
      text: text ?? this.text,
      postID: postID ?? this.postID,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'postID': postID,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      text: map['text'] as String,
      postID: map['postID'] as String,
      id: map['\$id'] as String,
      uid: map['uid'] as String,
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }
  @override
  String toString() {
    return 'NotificationModel(text: $text, postID: $postID, id: $id, uid: $uid, notificationType: $notificationType)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.postID == postID &&
        other.id == id &&
        other.uid == uid &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        postID.hashCode ^
        id.hashCode ^
        uid.hashCode ^
        notificationType.hashCode;
  }
}
