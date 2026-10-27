import 'user_model.dart';

class Reel {
  final String id;
  final User author;
  final String mediaUrl;
  final String caption;
  final String songTitle;
  final String songArtist;
  int likesCount;
  int commentsCount;
  int sharesCount;
  bool isLiked;
  bool isSaved;

  Reel({
    required this.id,
    required this.author,
    required this.mediaUrl,
    required this.caption,
    required this.songTitle,
    required this.songArtist,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'];
    final author = authorJson is Map<String, dynamic>
        ? User.fromJson(authorJson)
        : User(
            id: 'u',
            username: 'Creator',
            fullName: 'Creator',
            avatarUrl: '',
          );

    return Reel(
      id: json['id']?.toString() ?? '',
      author: author,
      mediaUrl: json['mediaUrl']?.toString() ?? json['media_url']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      songTitle: json['songTitle']?.toString() ?? json['song_title']?.toString() ?? 'Original Audio',
      songArtist: json['songArtist']?.toString() ?? json['song_artist']?.toString() ?? '',
      likesCount: (json['likesCount'] ?? json['likes_count'] ?? 0) as int,
      commentsCount: (json['commentsCount'] ?? json['comments_count'] ?? 0) as int,
      sharesCount: (json['sharesCount'] ?? json['shares_count'] ?? 0) as int,
      isLiked: json['isLiked'] == true || json['is_liked'] == true,
      isSaved: json['isSaved'] == true || json['is_saved'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'mediaUrl': mediaUrl,
      'caption': caption,
      'songTitle': songTitle,
      'songArtist': songArtist,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
    };
  }
}
