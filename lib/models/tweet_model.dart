import 'package:flutter/foundation.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIDs;
  final String id;
  final int reshareCount;
  final String retweetedBy;
  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIDs,
    required this.id,
    required this.reshareCount,
    required this.retweetedBy,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIDs,
    String? id,
    int? reshareCount,
    String? retweetedBy,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIDs: commentIDs ?? this.commentIDs,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'users': uid,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIDs': commentIDs,
      'reshareCount': reshareCount,
      'retweetedBy': retweetedBy,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] as String,
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['users']['\$id'] as String,
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from(map['likes']),
      commentIDs: List<String>.from(map['commentIDs']),
      id: map['\$id'] as String,
      reshareCount: map['reshareCount'] as int,
      retweetedBy: map['retweetedBy'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIDs: $commentIDs, id: $id, reshareCount: $reshareCount, retweetedBy: $retweetedBy)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIDs, commentIDs) &&
        other.id == id &&
        other.reshareCount == reshareCount &&
        other.retweetedBy == retweetedBy;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentIDs.hashCode ^
        id.hashCode ^
        reshareCount.hashCode ^
        retweetedBy.hashCode;
  }
}
