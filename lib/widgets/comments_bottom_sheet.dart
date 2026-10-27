import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../state/instagram_state.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Post post;

  const CommentsBottomSheet({super.key, required this.post});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _quickEmojis = [
    '❤️',
    '🙌',
    '🔥',
    '👏',
    '😍',
    '😮',
    '😂',
    '✨',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      InstagramScope.of(context).addComment(widget.post.id, text);
      _commentController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    // Find the latest post instance from state
    final currentPost = state.posts.firstWhere(
      (p) => p.id == widget.post.id,
      orElse: () => widget.post,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Comments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const Divider(height: 1),
          // Comments list
          Expanded(
            child: currentPost.comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 54,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No comments yet.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Start the conversation.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: currentPost.comments.length,
                    itemBuilder: (context, index) {
                      final comment = currentPost.comments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(comment.userAvatar),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${comment.username} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                            fontSize: 13,
                                          ),
                                        ),
                                        TextSpan(
                                          text: comment.text,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        comment.timeAgo,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      if (comment.likesCount > 0)
                                        Text(
                                          '${comment.likesCount} likes',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'Reply',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                comment.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: comment.isLiked
                                    ? Colors.red
                                    : Colors.grey.shade500,
                              ),
                              onPressed: () {
                                setState(() {
                                  comment.isLiked = !comment.isLiked;
                                  comment.likesCount +=
                                      comment.isLiked ? 1 : -1;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          // Quick Emojis Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _quickEmojis.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    _commentController.text += emoji;
                    _commentController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _commentController.text.length),
                    );
                  },
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              }).toList(),
            ),
          ),
          // Input bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(state.currentUser.avatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText:
                            'Add a comment for ${currentPost.author.username}...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _commentController,
                    builder: (context, value, child) {
                      final hasText = value.text.trim().isNotEmpty;
                      return TextButton(
                        onPressed: hasText ? _submitComment : null,
                        child: Text(
                          'Post',
                          style: TextStyle(
                            color: hasText
                                ? const Color(0xFF0095F6)
                                : Colors.blue.withOpacity(0.3),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
