import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommunityModel {
  final String communityName;
  final String communityId;
  final String communityBanner;
  final String communityAvatar;
  final List<String> communityMembers;
  final List<String> communityModerators;
  CommunityModel({
    required this.communityName,
    required this.communityId,
    required this.communityBanner,
    required this.communityAvatar,
    required this.communityMembers,
    required this.communityModerators,
  });

  CommunityModel copyWith({
    String? communityName,
    String? communityId,
    String? communityBanner,
    String? communityAvatar,
    List<String>? communityMembers,
    List<String>? communityModerators,
  }) {
    return CommunityModel(
      communityName: communityName ?? this.communityName,
      communityId: communityId ?? this.communityId,
      communityBanner: communityBanner ?? this.communityBanner,
      communityAvatar: communityAvatar ?? this.communityAvatar,
      communityMembers: communityMembers ?? this.communityMembers,
      communityModerators: communityModerators ?? this.communityModerators,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'communityName': communityName,
      'communityId': communityId,
      'communityBanner': communityBanner,
      'communityAvatar': communityAvatar,
      'communityMembers': communityMembers,
      'communityModerators': communityModerators,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
        communityName: map['communityName'],
        communityId: map['communityId'],
        communityBanner: map['communityBanner'],
        communityAvatar: map['communityAvatar'],
        communityMembers: List<String>.from((map['communityMembers'])),
        communityModerators: List<String>.from((map['communityModerators']))
        // Fix: When we call from DB we get members , It throws an error, List<String> is not a subtype of List<dynamic>.
        // and try to show, So we need remove  cast  List<String>
        );
  }

  @override
  String toString() {
    return 'CommunityModel(communityName: $communityName, communityId: $communityId, communityBanner: $communityBanner, communityAvatar: $communityAvatar, communityMembers: $communityMembers, communityModerators: $communityModerators)';
  }

  @override
  bool operator ==(covariant CommunityModel other) {
    if (identical(this, other)) return true;

    return other.communityName == communityName &&
        other.communityId == communityId &&
        other.communityBanner == communityBanner &&
        other.communityAvatar == communityAvatar &&
        listEquals(other.communityMembers, communityMembers) &&
        listEquals(other.communityModerators, communityModerators);
  }

  @override
  int get hashCode {
    return communityName.hashCode ^
        communityId.hashCode ^
        communityBanner.hashCode ^
        communityAvatar.hashCode ^
        communityMembers.hashCode ^
        communityModerators.hashCode;
  }
}
