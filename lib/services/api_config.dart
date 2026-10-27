import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Base URL for the REST API backend.
  /// On Web/Desktop or Android device with adb reverse, localhost works.
  /// On Android emulator, 10.0.2.2 points to host machine.
  static String _baseUrl = _defaultBaseUrl();

  static String get baseUrl => _baseUrl;

  static void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static String _defaultBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    try {
      if (Platform.isAndroid) {
        // Defaults to localhost:5000 (which is active via adb reverse tcp:5000 tcp:5000)
        // Can fallback to 10.0.2.2:5000 on emulators
        return 'http://localhost:5000';
      }
    } catch (_) {}
    return 'http://localhost:5000';
  }

  // Endpoints
  static String get health => '$_baseUrl/api/health';
  static String get register => '$_baseUrl/api/auth/register';
  static String get login => '$_baseUrl/api/auth/login';
  static String get me => '$_baseUrl/api/auth/me';
  static String get updateProfile => '$_baseUrl/api/auth/profile';

  static String get posts => '$_baseUrl/api/posts';
  static String postLike(String id) => '$_baseUrl/api/posts/$id/like';
  static String postSave(String id) => '$_baseUrl/api/posts/$id/save';
  static String postComments(String id) => '$_baseUrl/api/posts/$id/comments';
  static String get savedPosts => '$_baseUrl/api/posts/saved';

  static String get stories => '$_baseUrl/api/stories';
  static String storyView(String id) => '$_baseUrl/api/stories/$id/view';

  static String get reels => '$_baseUrl/api/reels';
  static String reelLike(String id) => '$_baseUrl/api/reels/$id/like';

  static String get messageThreads => '$_baseUrl/api/messages/threads';
  static String get sendMessage => '$_baseUrl/api/messages';

  static String get explore => '$_baseUrl/api/explore';
  static String get searchUsers => '$_baseUrl/api/users/search';
  static String followUser(String id) => '$_baseUrl/api/users/$id/follow';
}
