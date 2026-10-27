import 'user_model.dart';

class StoryItem {
  final String id;
  final String mediaUrl;
  final String timeAgo;
  final String caption;

  StoryItem({
    required this.id,
    required this.mediaUrl,
    required this.timeAgo,
    this.caption = '',
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      id: json['id']?.toString() ?? '',
      mediaUrl: json['mediaUrl']?.toString() ?? json['media_url']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? json['time_ago']?.toString() ?? 'Just now',
      caption: json['caption']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mediaUrl': mediaUrl,
      'timeAgo': timeAgo,
      'caption': caption,
    };
  }
}

class UserStory {
  final User user;
  final List<StoryItem> stories;
  bool isSeen;

  UserStory({
    required this.user,
    required this.stories,
    this.isSeen = false,
  });

  factory UserStory.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final user = userJson is Map<String, dynamic>
        ? User.fromJson(userJson)
        : User(
            id: 'u',
            username: 'User',
            fullName: 'User',
            avatarUrl: '',
          );

    final rawStories = json['stories'];
    List<StoryItem> parsedStories = [];
    if (rawStories is List) {
      parsedStories = rawStories
          .whereType<Map<String, dynamic>>()
          .map((s) => StoryItem.fromJson(s))
          .toList();
    }

    return UserStory(
      user: user,
      stories: parsedStories,
      isSeen: json['isSeen'] == true || json['is_seen'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'stories': stories.map((s) => s.toJson()).toList(),
      'isSeen': isSeen,
    };
  }
}
