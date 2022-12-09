// ignore_for_file: public_member_api_docs, sort_constructors_first

class Comment {
  final String id;
  final String postId;
  final String text;
  final String username;
  final DateTime createdAt;
  final String profilePicUrl;
  Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.username,
    required this.createdAt,
    required this.profilePicUrl,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? text,
    String? username,
    DateTime? createdAt,
    String? profilePicUrl,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'text': text,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      postId: map['postId'] as String,
      text: map['text'] as String,
      username: map['username'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      profilePicUrl: map['profilePicUrl'] as String,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, text: $text, username: $username, createdAt: $createdAt, profilePicUrl: $profilePicUrl)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.text == text &&
        other.username == username &&
        other.createdAt == createdAt &&
        other.profilePicUrl == profilePicUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        text.hashCode ^
        username.hashCode ^
        createdAt.hashCode ^
        profilePicUrl.hashCode;
  }
}
