class User {
  final String id;
  final String username;
  final String fullName;
  final String avatarUrl;
  final bool isVerified;
  final String bio;
  final String website;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    this.isVerified = false,
    this.bio = '',
    this.website = '',
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? json['avatar_url']?.toString() ?? '',
      isVerified: json['isVerified'] == true || json['is_verified'] == 1,
      bio: json['bio']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      postsCount: (json['postsCount'] ?? json['posts_count'] ?? 0) as int,
      followersCount: (json['followersCount'] ?? json['followers_count'] ?? 0) as int,
      followingCount: (json['followingCount'] ?? json['following_count'] ?? 0) as int,
      isFollowing: json['isFollowing'] == true || json['is_following'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'bio': bio,
      'website': website,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    bool? isVerified,
    String? bio,
    String? website,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
