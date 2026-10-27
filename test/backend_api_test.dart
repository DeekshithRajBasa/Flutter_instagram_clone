import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/comment_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/models/message_model.dart';
import 'package:instagram_clone/services/api_config.dart';

void main() {
  group('Backend Models & Serialization Tests', () {
    test('User fromJson and toJson', () {
      final user = User(
        id: 'u_123',
        username: 'testuser',
        fullName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'Hello world',
        website: 'https://example.com',
        postsCount: 5,
        followersCount: 100,
        followingCount: 50,
        isVerified: true,
      );

      final json = user.toJson();
      expect(json['id'], 'u_123');
      expect(json['username'], 'testuser');
      expect(json['isVerified'], true);

      final restored = User.fromJson(json);
      expect(restored.id, 'u_123');
      expect(restored.username, 'testuser');
      expect(restored.isVerified, true);
    });

    test('Post fromJson and toJson', () {
      final author = User(
        id: 'u_author',
        username: 'photographer',
        fullName: 'Photo Guy',
        avatarUrl: '',
      );

      final post = Post(
        id: 'p_101',
        author: author,
        imageUrls: ['https://example.com/pic.jpg'],
        caption: 'Sunset #vibes',
        location: 'California',
        timeAgo: '2h ago',
        likesCount: 42,
        isLiked: true,
        comments: [
          Comment(
            id: 'c_1',
            username: 'alice',
            userAvatar: '',
            text: 'Amazing shot!',
            timeAgo: '1h ago',
          ),
        ],
      );

      final json = post.toJson();
      expect(json['caption'], 'Sunset #vibes');
      expect(json['likesCount'], 42);

      final restored = Post.fromJson(json);
      expect(restored.id, 'p_101');
      expect(restored.author.username, 'photographer');
      expect(restored.caption, 'Sunset #vibes');
      expect(restored.comments.length, 1);
      expect(restored.comments.first.text, 'Amazing shot!');
    });

    test('Reel & Story serialization', () {
      final author = User(
        id: 'u_reel',
        username: 'reeler',
        fullName: 'Reels Guy',
        avatarUrl: '',
      );

      final reel = Reel(
        id: 'r_1',
        author: author,
        mediaUrl: 'https://example.com/video.mp4',
        caption: 'Funny moment',
        songTitle: 'Trending Beats',
        songArtist: 'DJ Pulse',
        likesCount: 1000,
      );

      final reelJson = reel.toJson();
      final restoredReel = Reel.fromJson(reelJson);
      expect(restoredReel.songTitle, 'Trending Beats');
      expect(restoredReel.likesCount, 1000);

      final story = UserStory(
        user: author,
        stories: [
          StoryItem(
            id: 's_1',
            mediaUrl: 'https://example.com/story.jpg',
            timeAgo: 'Just now',
          ),
        ],
      );

      final storyJson = story.toJson();
      final restoredStory = UserStory.fromJson(storyJson);
      expect(restoredStory.stories.length, 1);
      expect(restoredStory.stories.first.id, 's_1');
    });

    test('DirectMessage and ChatThread serialization', () {
      final peer = User(
        id: 'u_peer',
        username: 'bob',
        fullName: 'Bob Smith',
        avatarUrl: '',
      );

      final thread = ChatThread(
        id: 't_bob',
        peer: peer,
        lastActive: 'Active now',
        messages: [
          DirectMessage(
            id: 'm_1',
            senderId: 'u_peer',
            text: 'Hey there!',
            timestamp: DateTime(2026, 1, 1),
            isMe: false,
          ),
        ],
      );

      final json = thread.toJson();
      final restored = ChatThread.fromJson(json, currentUserId: 'my_id');
      expect(restored.peer.username, 'bob');
      expect(restored.messages.length, 1);
      expect(restored.messages.first.text, 'Hey there!');
      expect(restored.messages.first.isMe, false);
    });
  });

  group('API Config & Health Check Test', () {
    test('ApiConfig has valid endpoints', () {
      expect(ApiConfig.baseUrl, isNotEmpty);
      expect(ApiConfig.health, contains('/api/health'));
      expect(ApiConfig.login, contains('/api/auth/login'));
      expect(ApiConfig.register, contains('/api/auth/register'));
      expect(ApiConfig.posts, contains('/api/posts'));
      expect(ApiConfig.stories, contains('/api/stories'));
      expect(ApiConfig.reels, contains('/api/reels'));
      expect(ApiConfig.explore, contains('/api/explore'));
    });
  });
}
