import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../state/instagram_state.dart';

class StoryViewerScreen extends StatefulWidget {
  final UserStory userStory;

  const StoryViewerScreen({super.key, required this.userStory});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animController;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onStoryNext();
      }
    });

    _startCurrentStory();

    // Mark as seen in state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InstagramScope.of(context).markStorySeen(widget.userStory.user.id);
    });
  }

  void _startCurrentStory() {
    _animController.stop();
    _animController.reset();
    _animController.forward();
  }

  void _onStoryNext() {
    if (_currentIndex < widget.userStory.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startCurrentStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _onStoryPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _startCurrentStory();
    } else {
      _startCurrentStory();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.userStory.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (_) => _animController.stop(),
          onTapUp: (_) => _animController.forward(),
          child: Stack(
            children: [
              // Main Story Media
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    story.mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white54, size: 48),
                      ),
                    ),
                  ),
                ),
              ),

              // Touch zones for tapping left/right
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _onStoryPrevious,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _onStoryNext,
                      ),
                    ),
                  ],
                ),
              ),

              // Gradient Header Shade
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Progress bars & User info Header
              Positioned(
                top: 8,
                left: 12,
                right: 12,
                child: Column(
                  children: [
                    // Segmented Progress Bar
                    Row(
                      children: List.generate(
                        widget.userStory.stories.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: AnimatedBuilder(
                              animation: _animController,
                              builder: (context, child) {
                                double value = 0.0;
                                if (index < _currentIndex) {
                                  value = 1.0;
                                } else if (index == _currentIndex) {
                                  value = _animController.value;
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.35),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                    minHeight: 2.5,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // User Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage:
                              NetworkImage(widget.userStory.user.avatarUrl),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.userStory.user.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          story.timeAgo,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 26),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Story Caption if present
              if (story.caption.isNotEmpty)
                Positioned(
                  bottom: 74,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      story.caption,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // Bottom Reply Bar
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _replyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Reply to ${widget.userStory.user.username}...',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (text) {
                            if (text.trim().isNotEmpty) {
                              _replyController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reply sent!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sent ❤️ reaction!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined,
                          color: Colors.white, size: 26),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
