class Comment {
  final String id;
  final String username;
  final String userAvatar;
  final String text;
  final String timeAgo;
  int likesCount;
  bool isLiked;

  Comment({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.text,
    required this.timeAgo,
    this.likesCount = 0,
    this.isLiked = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      userAvatar: json['userAvatar']?.toString() ?? json['user_avatar']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? json['time_ago']?.toString() ?? 'Just now',
      likesCount: (json['likesCount'] ?? 0) as int,
      isLiked: json['isLiked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatar': userAvatar,
      'text': text,
      'timeAgo': timeAgo,
      'likesCount': likesCount,
      'isLiked': isLiked,
    };
  }
}
