import 'dart:async';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/comment_model.dart';
import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/reel_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../services/instagram_api_service.dart';

class InstagramState extends ChangeNotifier {
  late User _currentUser;
  late List<UserStory> _stories;
  late List<Post> _posts;
  late List<Reel> _reels;
  late List<ChatThread> _chatThreads;
  late List<String> _exploreImages;
  int _unreadNotifications = 0;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _backendConnected = false;

  InstagramState() {
    _currentUser = MockData.defaultEmptyUser;
    _stories = MockData.getStories();
    _posts = MockData.getPosts();
    _reels = MockData.getReels();
    _chatThreads = MockData.getChatThreads();
    _exploreImages = MockData.getExploreImages();

    // Initialize session and sync with backend
    _initSession();
  }

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get backendConnected => _backendConnected;
  User get currentUser => _currentUser;
  List<UserStory> get stories => _stories;
  List<Post> get posts => _posts;
  List<Reel> get reels => _reels;
  List<ChatThread> get chatThreads => _chatThreads;
  List<String> get exploreImages => _exploreImages;
  int get unreadNotifications => _unreadNotifications;

  List<Post> get savedPosts => _posts.where((p) => p.isSaved).toList();
  List<Post> get myPosts =>
      _posts.where((p) => p.author.id == _currentUser.id).toList();

  int get unreadMessagesCount =>
      _chatThreads.where((thread) => thread.hasUnread).length;

  Future<void> _initSession() async {
    // 1. Check health
    _backendConnected = await InstagramApiService.isBackendAvailable();

    // 2. Load saved user session
    final savedUser = await InstagramApiService.loadSavedUser();
    if (savedUser != null && savedUser.username.isNotEmpty) {
      _currentUser = savedUser;
      _isLoggedIn = true;
      notifyListeners();

      // Fetch fresh data from backend
      await refreshData();
    } else {
      // Fetch public posts/explore
      await refreshData();
    }
  }

  /// Full data refresh from backend
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUserId = _currentUser.id.isNotEmpty ? _currentUser.id : null;

      final results = await Future.wait([
        InstagramApiService.getPosts(currentUserId: currentUserId),
        InstagramApiService.getStories(currentUserId: currentUserId),
        InstagramApiService.getReels(currentUserId: currentUserId),
        InstagramApiService.getExploreImages(),
        if (_isLoggedIn)
          InstagramApiService.getThreads(_currentUser.id)
        else
          Future.value(<ChatThread>[]),
      ]);

      final fetchedPosts = results[0] as List<Post>;
      final fetchedStories = results[1] as List<UserStory>;
      final fetchedReels = results[2] as List<Reel>;
      final fetchedExplore = results[3] as List<String>;
      final fetchedThreads = results[4] as List<ChatThread>;

      if (fetchedPosts.isNotEmpty) {
        _posts = fetchedPosts;
      }
      if (fetchedStories.isNotEmpty) {
        _stories = fetchedStories;
      }
      if (fetchedReels.isNotEmpty) {
        _reels = fetchedReels;
      }
      if (fetchedExplore.isNotEmpty) {
        _exploreImages = fetchedExplore;
      }
      if (fetchedThreads.isNotEmpty) {
        _chatThreads = fetchedThreads;
      }

      // If user profile is available on backend, sync profile stats
      if (_isLoggedIn && _currentUser.id.isNotEmpty) {
        final profile = await InstagramApiService.getCurrentUser(_currentUser.id);
        if (profile != null) {
          _currentUser = profile;
        }
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- AUTH METHODS ---

  Future<void> login({
    String? username,
    String? fullName,
    String? avatarUrl,
    String? password,
  }) async {
    final cleanUsername = username?.trim() ?? '';
    if (cleanUsername.isNotEmpty) {
      _currentUser = _currentUser.copyWith(
        username: cleanUsername,
        fullName: fullName ?? cleanUsername,
        avatarUrl: avatarUrl ?? _currentUser.avatarUrl,
      );
    }
    _isLoggedIn = true;
    notifyListeners();

    // Call backend API in background
    try {
      final backendUser = await InstagramApiService.login(
        usernameOrEmail: cleanUsername.isNotEmpty ? cleanUsername : 'user',
        password: password,
      );
      if (backendUser != null) {
        _currentUser = backendUser;
        await refreshData();
      }
    } catch (_) {}

    notifyListeners();
  }

  Future<void> register({
    required String username,
    String? fullName,
    String? emailOrPhone,
    String? password,
    String? avatarUrl,
  }) async {
    _currentUser = _currentUser.copyWith(
      username: username.trim(),
      fullName: fullName ?? username.trim(),
      avatarUrl: avatarUrl ?? '',
    );
    _isLoggedIn = true;
    notifyListeners();

    try {
      final user = await InstagramApiService.register(
        username: username,
        fullName: fullName,
        emailOrPhone: emailOrPhone,
        password: password,
        avatarUrl: avatarUrl,
      );
      if (user != null) {
        _currentUser = user;
        await refreshData();
      }
    } catch (_) {}

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = MockData.defaultEmptyUser;
    _posts = [];
    _stories = [];
    _chatThreads = [];
    await InstagramApiService.clearUserSession();
    notifyListeners();
  }

  // --- POSTS METHODS ---

  void togglePostLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      if (post.isLiked) {
        post.isLiked = false;
        post.likesCount--;
      } else {
        post.isLiked = true;
        post.likesCount++;
      }
      notifyListeners();

      // Persist to backend
      InstagramApiService.togglePostLike(
        postId: postId,
        userId: _currentUser.id,
      );
    }
  }

  void togglePostSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isSaved = !_posts[index].isSaved;
      notifyListeners();

      // Persist to backend
      InstagramApiService.togglePostSave(
        postId: postId,
        userId: _currentUser.id,
      );
    }
  }

  void addComment(String postId, String commentText) {
    if (commentText.trim().isEmpty) return;
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final newComment = Comment(
        id: 'c_${DateTime.now().millisecondsSinceEpoch}',
        username: _currentUser.username,
        userAvatar: _currentUser.avatarUrl,
        text: commentText.trim(),
        timeAgo: 'Just now',
      );
      _posts[index].comments.insert(0, newComment);
      notifyListeners();

      // Persist to backend
      InstagramApiService.addComment(
        postId: postId,
        userId: _currentUser.id,
        text: commentText.trim(),
      );
    }
  }

  void addNewPost({
    required String imageUrl,
    required String caption,
    String location = '',
  }) {
    final tempId = 'p_${DateTime.now().millisecondsSinceEpoch}';
    final newPost = Post(
      id: tempId,
      author: _currentUser,
      imageUrls: [imageUrl],
      caption: caption,
      location: location,
      timeAgo: 'Just now',
      likesCount: 0,
      isLiked: false,
      isSaved: false,
      comments: [],
    );
    _posts.insert(0, newPost);
    _currentUser = _currentUser.copyWith(
      postsCount: _currentUser.postsCount + 1,
    );
    notifyListeners();

    // Persist to backend
    InstagramApiService.createPost(
      userId: _currentUser.id,
      imageUrl: imageUrl,
      caption: caption,
      location: location,
    ).then((saved) {
      if (saved != null) {
        final idx = _posts.indexWhere((p) => p.id == tempId);
        if (idx != -1) {
          _posts[idx] = saved;
          notifyListeners();
        }
      }
    });
  }

  // --- REELS METHODS ---

  void toggleReelLike(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index != -1) {
      final reel = _reels[index];
      if (reel.isLiked) {
        reel.isLiked = false;
        reel.likesCount--;
      } else {
        reel.isLiked = true;
        reel.likesCount++;
      }
      notifyListeners();

      InstagramApiService.toggleReelLike(
        reelId: reelId,
        userId: _currentUser.id,
      );
    }
  }

  // --- STORIES METHODS ---

  void markStorySeen(String storyUserId) {
    final index = _stories.indexWhere((s) => s.user.id == storyUserId);
    if (index != -1) {
      _stories[index].isSeen = true;
      notifyListeners();

      for (final item in _stories[index].stories) {
        InstagramApiService.markStoryViewed(
          storyId: item.id,
          userId: _currentUser.id,
        );
      }
    }
  }

  void addStory(String mediaUrl) {
    final newItem = StoryItem(
      id: 's_${DateTime.now().millisecondsSinceEpoch}',
      mediaUrl: mediaUrl,
      timeAgo: 'Just now',
    );
    final userStoryIndex =
        _stories.indexWhere((s) => s.user.id == _currentUser.id);
    if (userStoryIndex != -1) {
      _stories[userStoryIndex].stories.add(newItem);
      _stories[userStoryIndex].isSeen = false;
    } else {
      _stories.insert(
        0,
        UserStory(
          user: _currentUser,
          stories: [newItem],
          isSeen: false,
        ),
      );
    }
    notifyListeners();

    InstagramApiService.addStory(
      userId: _currentUser.id,
      mediaUrl: mediaUrl,
    );
  }

  // --- MESSAGES METHODS ---

  void sendMessage(String threadId, String text) {
    if (text.trim().isEmpty) return;
    final index = _chatThreads.indexWhere((t) => t.id == threadId);
    if (index != -1) {
      final thread = _chatThreads[index];
      final newMessage = DirectMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUser.id,
        text: text.trim(),
        timestamp: DateTime.now(),
        isMe: true,
      );
      thread.messages.add(newMessage);
      notifyListeners();

      InstagramApiService.sendMessage(
        senderId: _currentUser.id,
        receiverId: thread.peer.id,
        text: text.trim(),
      );
    }
  }

  void markThreadRead(String threadId) {
    final index = _chatThreads.indexWhere((t) => t.id == threadId);
    if (index != -1 && _chatThreads[index].hasUnread) {
      _chatThreads[index] = ChatThread(
        id: _chatThreads[index].id,
        peer: _chatThreads[index].peer,
        messages: _chatThreads[index].messages,
        hasUnread: false,
        lastActive: _chatThreads[index].lastActive,
      );
      notifyListeners();
    }
  }

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  void updateBio(String bio, String website) {
    _currentUser = _currentUser.copyWith(bio: bio, website: website);
    notifyListeners();

    InstagramApiService.updateProfile(
      userId: _currentUser.id,
      bio: bio,
      website: website,
    );
  }
}

class InstagramScope extends InheritedNotifier<InstagramState> {
  const InstagramScope({
    super.key,
    required InstagramState state,
    required super.child,
  }) : super(notifier: state);

  static InstagramState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<InstagramScope>();
    assert(scope != null, 'No InstagramScope found in context');
    return scope!.notifier!;
  }
}
