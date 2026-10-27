import 'package:flutter/material.dart';
import '../models/reel_model.dart';
import '../state/instagram_state.dart';
import '../widgets/heart_animation_widget.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _discAnimController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _discAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _discAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final reels = state.reels;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vertical PageView of Reels or Empty State
          if (reels.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white60, width: 2),
                      ),
                      child: const Icon(Icons.video_collection_outlined,
                          size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'No Reels Yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Reels are a new way to create and discover short, entertaining videos on Instagram.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                final reel = reels[index];
                return _ReelPageItem(
                  reel: reel,
                  discAnim: _discAnimController,
                );
              },
            ),

          // Top Header Overlay
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined,
                      color: Colors.white, size: 26),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelPageItem extends StatefulWidget {
  final Reel reel;
  final Animation<double> discAnim;

  const _ReelPageItem({
    required this.reel,
    required this.discAnim,
  });

  @override
  State<_ReelPageItem> createState() => _ReelPageItemState();
}

class _ReelPageItemState extends State<_ReelPageItem> {
  bool _isHeartAnimating = false;
  bool _isFollowing = false;

  void _onDoubleTap() {
    setState(() => _isHeartAnimating = true);
    if (!widget.reel.isLiked) {
      InstagramScope.of(context).toggleReelLike(widget.reel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final reel = widget.reel;

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image / Video Simulation
          Image.network(
            reel.mediaUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
              ),
            ),
          ),

          // Gradient Vignette
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Burst Heart on Double Tap
          Center(
            child: Opacity(
              opacity: _isHeartAnimating ? 1 : 0,
              child: HeartAnimationWidget(
                isAnimating: _isHeartAnimating,
                onEnd: () => setState(() => _isHeartAnimating = false),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                  shadows: [
                    Shadow(color: Colors.black45, blurRadius: 16),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Left: Author & Music Info
          Positioned(
            left: 16,
            bottom: 24,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(reel.author.avatarUrl),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      reel.author.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (reel.author.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified,
                          color: Color(0xFF0095F6), size: 14),
                    ],
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _isFollowing = !_isFollowing);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: _isFollowing
                              ? Colors.white54
                              : Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        _isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Caption
                Text(
                  reel.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Music Ticker Row
                Row(
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${reel.songTitle} • ${reel.songArtist}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right Action Column
          Positioned(
            right: 12,
            bottom: 24,
            child: Column(
              children: [
                // Like Button
                IconButton(
                  icon: Icon(
                    reel.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: reel.isLiked ? const Color(0xFFED4956) : Colors.white,
                    size: 32,
                  ),
                  onPressed: () => state.toggleReelLike(reel.id),
                ),
                Text(
                  '${reel.likesCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Comment Button
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded,
                      color: Colors.white, size: 30),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reel comments coming up!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                Text(
                  '${reel.commentsCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Share Button
                IconButton(
                  icon: const Icon(Icons.send_outlined,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reel shared to Direct!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                Text(
                  '${reel.sharesCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // More Options
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      color: Colors.white, size: 26),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),

                // Rotating Vinyl Disc
                RotationTransition(
                  turns: widget.discAnim,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(reel.author.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
