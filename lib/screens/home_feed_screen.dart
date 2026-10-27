import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../state/instagram_state.dart';
import '../widgets/post_card.dart';
import '../widgets/story_circle.dart';
import 'direct_messages_screen.dart';
import 'notifications_screen.dart';
import 'story_viewer_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  final VoidCallback? onAddPost;

  const HomeFeedScreen({super.key, this.onAddPost});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {});
  }

  void _promptAddStory(BuildContext context, InstagramState state) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to Your Story'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Paste a photo or image URL to share to your story:'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Photo URL',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  state.addStory(controller.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Story added!')),
                  );
                }
              },
              child: const Text('Share to Story'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final stories = state.stories;
    final posts = state.posts;

    // Ensure current user story is always present as first item in tray
    final myStoryIndex =
        stories.indexWhere((s) => s.user.id == state.currentUser.id);
    final myStory = myStoryIndex != -1
        ? stories[myStoryIndex]
        : UserStory(user: state.currentUser, stories: []);

    final allStories = [
      myStory,
      ...stories.where((s) => s.user.id != state.currentUser.id),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                color: Colors.black87, size: 20),
          ],
        ),
        actions: [
          // Heart Notifications Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: Colors.black87, size: 27),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              if (state.unreadNotifications > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(3.5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFED4956),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.unreadNotifications}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Direct Messages (Messenger) Icon with Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chat_outlined,
                    color: Colors.black87, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DirectMessagesScreen(),
                    ),
                  );
                },
              ),
              if (state.unreadMessagesCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(3.5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFED4956),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.unreadMessagesCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF0095F6),
        child: ListView(
          children: [
            // Stories Tray
            Container(
              height: 118,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                itemCount: allStories.length,
                itemBuilder: (context, index) {
                  final story = allStories[index];
                  final isCurrent = index == 0;
                  return StoryCircle(
                    userStory: story,
                    isCurrentUser: isCurrent,
                    onTap: () {
                      if (isCurrent && story.stories.isEmpty) {
                        _promptAddStory(context, state);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryViewerScreen(userStory: story),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            // Posts Feed or Authentic Empty State
            if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 44,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to Instagram',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you share photos and videos, they will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        widget.onAddPost?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0095F6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Share your first photo',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...posts.map((post) => PostCard(post: post)),
          ],
        ),
      ),
    );
  }
}
