import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/reel_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class InstagramApiService {
  static const String _prefUserKey = 'saved_current_user';

  // --- HEALTH CHECK ---
  static Future<bool> isBackendAvailable() async {
    final res = await ApiClient.get(ApiConfig.health);
    return res.success;
  }

  // --- SESSION PERSISTENCE ---
  static Future<void> saveUserSession(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefUserKey, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  static Future<User?> loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_prefUserKey);
      if (str != null && str.isNotEmpty) {
        final decoded = jsonDecode(str) as Map<String, dynamic>;
        return User.fromJson(decoded);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefUserKey);
    } catch (_) {}
  }

  // --- AUTH SERVICES ---

  static Future<User?> register({
    required String username,
    String? fullName,
    String? emailOrPhone,
    String? password,
    String? avatarUrl,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.register,
      body: {
        'username': username,
        'fullName': fullName,
        'emailOrPhone': emailOrPhone,
        'password': password,
        'avatarUrl': avatarUrl,
      },
    );

    if (res.success && res.data != null && res.data!['user'] != null) {
      final user = User.fromJson(res.data!['user'] as Map<String, dynamic>);
      await saveUserSession(user);
      return user;
    }
    return null;
  }

  static Future<User?> login({
    required String usernameOrEmail,
    String? password,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.login,
      body: {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      },
    );

    if (res.success && res.data != null && res.data!['user'] != null) {
      final user = User.fromJson(res.data!['user'] as Map<String, dynamic>);
      await saveUserSession(user);
      return user;
    }
    return null;
  }

  static Future<User?> getCurrentUser(String userId) async {
    final res = await ApiClient.get(
      ApiConfig.me,
      queryParams: {'userId': userId},
    );

    if (res.success && res.data != null && res.data!['user'] != null) {
      final user = User.fromJson(res.data!['user'] as Map<String, dynamic>);
      await saveUserSession(user);
      return user;
    }
    return null;
  }

  static Future<User?> updateProfile({
    required String userId,
    String? bio,
    String? website,
    String? fullName,
    String? avatarUrl,
  }) async {
    final res = await ApiClient.put(
      ApiConfig.updateProfile,
      body: {
        'userId': userId,
        'bio': bio,
        'website': website,
        'fullName': fullName,
        'avatarUrl': avatarUrl,
      },
    );

    if (res.success && res.data != null && res.data!['user'] != null) {
      final user = User.fromJson(res.data!['user'] as Map<String, dynamic>);
      await saveUserSession(user);
      return user;
    }
    return null;
  }

  // --- POSTS SERVICES ---

  static Future<List<Post>> getPosts({String? currentUserId}) async {
    final res = await ApiClient.get(
      ApiConfig.posts,
      queryParams: currentUserId != null ? {'userId': currentUserId} : null,
    );

    if (res.success && res.data != null && res.data!['posts'] is List) {
      final list = res.data!['posts'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((p) => Post.fromJson(p))
          .toList();
    }
    return [];
  }

  static Future<Post?> createPost({
    required String userId,
    required String imageUrl,
    String caption = '',
    String location = '',
  }) async {
    final res = await ApiClient.post(
      ApiConfig.posts,
      body: {
        'userId': userId,
        'imageUrl': imageUrl,
        'caption': caption,
        'location': location,
      },
    );

    if (res.success && res.data != null && res.data!['post'] != null) {
      return Post.fromJson(res.data!['post'] as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> togglePostLike({
    required String postId,
    required String userId,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.postLike(postId),
      body: {'userId': userId},
    );
    return res.success;
  }

  static Future<bool> togglePostSave({
    required String postId,
    required String userId,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.postSave(postId),
      body: {'userId': userId},
    );
    return res.success;
  }

  static Future<Comment?> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.postComments(postId),
      body: {
        'userId': userId,
        'text': text,
      },
    );

    if (res.success && res.data != null && res.data!['comment'] != null) {
      return Comment.fromJson(res.data!['comment'] as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<Post>> getSavedPosts(String userId) async {
    final res = await ApiClient.get(
      ApiConfig.savedPosts,
      queryParams: {'userId': userId},
    );

    if (res.success && res.data != null && res.data!['posts'] is List) {
      final list = res.data!['posts'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((p) => Post.fromJson(p))
          .toList();
    }
    return [];
  }

  // --- STORIES SERVICES ---

  static Future<List<UserStory>> getStories({String? currentUserId}) async {
    final res = await ApiClient.get(
      ApiConfig.stories,
      queryParams: currentUserId != null ? {'currentUserId': currentUserId} : null,
    );

    if (res.success && res.data != null && res.data!['stories'] is List) {
      final list = res.data!['stories'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((s) => UserStory.fromJson(s))
          .toList();
    }
    return [];
  }

  static Future<bool> addStory({
    required String userId,
    required String mediaUrl,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.stories,
      body: {
        'userId': userId,
        'mediaUrl': mediaUrl,
      },
    );
    return res.success;
  }

  static Future<void> markStoryViewed({
    required String storyId,
    required String userId,
  }) async {
    await ApiClient.post(
      ApiConfig.storyView(storyId),
      body: {'userId': userId},
    );
  }

  // --- REELS SERVICES ---

  static Future<List<Reel>> getReels({String? currentUserId}) async {
    final res = await ApiClient.get(
      ApiConfig.reels,
      queryParams: currentUserId != null ? {'userId': currentUserId} : null,
    );

    if (res.success && res.data != null && res.data!['reels'] is List) {
      final list = res.data!['reels'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((r) => Reel.fromJson(r))
          .toList();
    }
    return [];
  }

  static Future<bool> toggleReelLike({
    required String reelId,
    required String userId,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.reelLike(reelId),
      body: {'userId': userId},
    );
    return res.success;
  }

  // --- MESSAGES SERVICES ---

  static Future<List<ChatThread>> getThreads(String userId) async {
    final res = await ApiClient.get(
      ApiConfig.messageThreads,
      queryParams: {'userId': userId},
    );

    if (res.success && res.data != null && res.data!['threads'] is List) {
      final list = res.data!['threads'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((t) => ChatThread.fromJson(t, currentUserId: userId))
          .toList();
    }
    return [];
  }

  static Future<DirectMessage?> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.sendMessage,
      body: {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
      },
    );

    if (res.success && res.data != null && res.data!['message'] != null) {
      return DirectMessage.fromJson(
        res.data!['message'] as Map<String, dynamic>,
        currentUserId: senderId,
      );
    }
    return null;
  }

  // --- EXPLORE & USERS SERVICES ---

  static Future<List<String>> getExploreImages() async {
    final res = await ApiClient.get(ApiConfig.explore);
    if (res.success && res.data != null && res.data!['images'] is List) {
      return (res.data!['images'] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  static Future<List<User>> searchUsers({
    String query = '',
    String? currentUserId,
  }) async {
    final params = <String, String>{};
    if (query.isNotEmpty) params['q'] = query;
    if (currentUserId != null) params['userId'] = currentUserId;

    final res = await ApiClient.get(ApiConfig.searchUsers, queryParams: params);
    if (res.success && res.data != null && res.data!['users'] is List) {
      final list = res.data!['users'] as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map((u) => User.fromJson(u))
          .toList();
    }
    return [];
  }

  static Future<bool> toggleFollowUser({
    required String targetUserId,
    required String currentUserId,
  }) async {
    final res = await ApiClient.post(
      ApiConfig.followUser(targetUserId),
      body: {'currentUserId': currentUserId},
    );
    return res.success;
  }
}
