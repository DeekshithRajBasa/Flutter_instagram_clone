import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../state/instagram_state.dart';
import 'comments_bottom_sheet.dart';
import 'heart_animation_widget.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentImageIndex = 0;
  bool _isHeartAnimating = false;
  bool _isCaptionExpanded = false;

  void _onDoubleTapLike() {
    setState(() {
      _isHeartAnimating = true;
    });
    final state = InstagramScope.of(context);
    if (!widget.post.isLiked) {
      state.togglePostLike(widget.post.id);
    }
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CommentsBottomSheet(post: widget.post),
      ),
    );
  }

  void _showShareDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Share to Direct',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0095F6),
                    child: Icon(Icons.send_rounded, color: Colors.white),
                  ),
                  title: const Text('Send to friends'),
                  subtitle: const Text('Direct message this post'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post shared to Direct!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.link, color: Colors.white),
                  ),
                  title: const Text('Copy Link'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: Text(widget.post.isSaved ? 'Remove from Saved' : 'Save'),
                onTap: () {
                  Navigator.pop(context);
                  InstagramScope.of(context).togglePostSave(widget.post.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('QR Code'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.report_problem_outlined,
                    color: Colors.red),
                title: const Text('Report',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for reporting.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(post.author.avatarUrl),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.author.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                        if (post.author.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF0095F6),
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                    if (post.location.isNotEmpty)
                      Text(
                        post.location,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.black87),
                onPressed: _showMoreOptions,
              ),
            ],
          ),
        ),

        // Post Media with double-tap burst heart animation
        GestureDetector(
          onDoubleTap: _onDoubleTapLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: post.imageUrls.length > 1
                    ? PageView.builder(
                        itemCount: post.imageUrls.length,
                        onPageChanged: (i) {
                          setState(() => _currentImageIndex = i);
                        },
                        itemBuilder: (context, idx) {
                          return Image.network(
                            post.imageUrls[idx],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 40),
                            ),
                          );
                        },
                      )
                    : Image.network(
                        post.imageUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
              ),
              // Multi-image badge indicator at top right
              if (post.imageUrls.length > 1)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${post.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Animated Burst Heart
              Opacity(
                opacity: _isHeartAnimating ? 1 : 0,
                child: HeartAnimationWidget(
                  isAnimating: _isHeartAnimating,
                  duration: const Duration(milliseconds: 600),
                  onEnd: () => setState(() => _isHeartAnimating = false),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 96,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Action Buttons Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            children: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(post.isLiked),
                    color: post.isLiked ? const Color(0xFFED4956) : Colors.black87,
                    size: 27,
                  ),
                ),
                onPressed: () => state.togglePostLike(post.id),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.black87,
                  size: 25,
                ),
                onPressed: _openComments,
              ),
              IconButton(
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.black87,
                  size: 24,
                ),
                onPressed: _showShareDialog,
              ),
              if (post.imageUrls.length > 1)
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        post.imageUrls.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: index == _currentImageIndex ? 6 : 5,
                          height: index == _currentImageIndex ? 6 : 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentImageIndex
                                ? const Color(0xFF0095F6)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              IconButton(
                icon: Icon(
                  post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.black87,
                  size: 27,
                ),
                onPressed: () => state.togglePostSave(post.id),
              ),
            ],
          ),
        ),

        // Likes Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            '${post.likesCount} likes',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: Colors.black87,
            ),
          ),
        ),

        // Caption with 'more' expansion
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${post.author.username} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontSize: 13.5,
                  ),
                ),
                TextSpan(
                  text: _isCaptionExpanded
                      ? post.caption
                      : (post.caption.length > 90
                          ? '${post.caption.substring(0, 90)}... '
                          : post.caption),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13.5,
                  ),
                ),
                if (post.caption.length > 90 && !_isCaptionExpanded)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _isCaptionExpanded = true);
                      },
                      child: Text(
                        'more',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Comments Count Link
        if (post.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
            child: GestureDetector(
              onTap: _openComments,
              child: Text(
                'View all ${post.comments.length} comments',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
          ),

        // Timestamp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          child: Text(
            post.timeAgo,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
