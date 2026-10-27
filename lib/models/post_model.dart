import 'comment_model.dart';
import 'user_model.dart';

class Post {
  final String id;
  final User author;
  final List<String> imageUrls;
  final String caption;
  final String location;
  final String timeAgo;
  int likesCount;
  bool isLiked;
  bool isSaved;
  List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.imageUrls,
    required this.caption,
    this.location = '',
    required this.timeAgo,
    this.likesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  factory Post.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'];
    final author = authorJson is Map<String, dynamic>
        ? User.fromJson(authorJson)
        : User(
            id: json['userId']?.toString() ?? 'u',
            username: 'User',
            fullName: 'Instagram User',
            avatarUrl: '',
          );

    final rawImages = json['imageUrls'] ?? json['image_urls'];
    List<String> images = [];
    if (rawImages is List) {
      images = rawImages.map((e) => e.toString()).toList();
    } else if (json['imageUrl'] != null) {
      images = [json['imageUrl'].toString()];
    } else if (json['image_url'] != null) {
      images = [json['image_url'].toString()];
    }

    final rawComments = json['comments'];
    List<Comment> parsedComments = [];
    if (rawComments is List) {
      parsedComments = rawComments
          .whereType<Map<String, dynamic>>()
          .map((c) => Comment.fromJson(c))
          .toList();
    }

    return Post(
      id: json['id']?.toString() ?? '',
      author: author,
      imageUrls: images,
      caption: json['caption']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      timeAgo: json['timeAgo']?.toString() ?? json['time_ago']?.toString() ?? 'Just now',
      likesCount: (json['likesCount'] ?? json['likes_count'] ?? 0) as int,
      isLiked: json['isLiked'] == true || json['is_liked'] == true,
      isSaved: json['isSaved'] == true || json['is_saved'] == true,
      comments: parsedComments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'imageUrls': imageUrls,
      'caption': caption,
      'location': location,
      'timeAgo': timeAgo,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}
