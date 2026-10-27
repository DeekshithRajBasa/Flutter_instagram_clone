import '../models/message_model.dart';
import '../models/post_model.dart';
import '../models/reel_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';

class MockData {
  static final User defaultEmptyUser = User(
    id: 'user_current',
    username: '',
    fullName: '',
    avatarUrl: '',
    isVerified: false,
    bio: '',
    website: '',
    postsCount: 0,
    followersCount: 0,
    followingCount: 0,
    isFollowing: false,
  );

  static final List<User> suggestedUsers = [
    User(
      id: 'u1',
      username: 'photography_hub',
      fullName: 'Photography Hub',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
      isVerified: true,
      bio: 'Daily featured community captures',
      followersCount: 120000,
      followingCount: 150,
    ),
    User(
      id: 'u2',
      username: 'art_creators',
      fullName: 'Art & Design',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
      isVerified: true,
      bio: 'Curated digital art and design',
      followersCount: 45000,
      followingCount: 220,
    ),
  ];

  static List<UserStory> getStories() => [];
  static List<Post> getPosts() => [];
  static List<Reel> getReels() => [];
  static List<ChatThread> getChatThreads() => [];
  static List<String> getExploreImages() => [];
}
