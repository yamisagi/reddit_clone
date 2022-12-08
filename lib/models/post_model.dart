// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? body;
  final String communityName;
  final String communityProfileImg;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String author;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.body,
    required this.communityName,
    required this.communityProfileImg,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.author,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? body,
    String? communityName,
    String? communityProfileImg,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? author,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      body: body ?? this.body,
      communityName: communityName ?? this.communityName,
      communityProfileImg: communityProfileImg ?? this.communityProfileImg,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      author: author ?? this.author,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'body': body,
      'communityName': communityName,
      'communityProfileImg': communityProfileImg,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'author': author,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      communityName: map['communityName'] as String,
      communityProfileImg: map['communityProfileImg'] as String,
      upVotes: List.from(map['upVotes'] as List),
      downVotes: List.from(map['downVotes'] as List),
      commentCount: map['commentCount'] as int,
      author: map['author'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: List.from(
        (map['awards'] as List),
      ),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, body: $body, communityName: $communityName, communityProfileImg: $communityProfileImg, upVotes: $upVotes, downVotes: $downVotes, commentCount: $commentCount, author: $author, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.body == body &&
        other.communityName == communityName &&
        other.communityProfileImg == communityProfileImg &&
        listEquals(other.upVotes, upVotes) &&
        listEquals(other.downVotes, downVotes) &&
        other.commentCount == commentCount &&
        other.author == author &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        body.hashCode ^
        communityName.hashCode ^
        communityProfileImg.hashCode ^
        upVotes.hashCode ^
        downVotes.hashCode ^
        commentCount.hashCode ^
        author.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        awards.hashCode;
  }
}
