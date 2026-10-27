import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../state/instagram_state.dart';

class ChatConversationScreen extends StatefulWidget {
  final ChatThread thread;

  const ChatConversationScreen({super.key, required this.thread});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InstagramScope.of(context).markThreadRead(widget.thread.id);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      InstagramScope.of(context).sendMessage(widget.thread.id, text);
      _textController.clear();
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final currentThread = state.chatThreads.firstWhere(
      (t) => t.id == widget.thread.id,
      orElse: () => widget.thread,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(currentThread.peer.avatarUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      currentThread.peer.fullName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (currentThread.peer.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified,
                          color: Color(0xFF0095F6), size: 13),
                    ],
                  ],
                ),
                Text(
                  currentThread.lastActive,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: currentThread.messages.length,
              itemBuilder: (context, index) {
                final msg = currentThread.messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment:
                        msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: msg.isMe
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF833AB4),
                                  Color(0xFF405DE6),
                                ],
                              )
                            : null,
                        color: msg.isMe ? null : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(msg.isMe ? 20 : 4),
                          bottomRight: Radius.circular(msg.isMe ? 4 : 20),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isMe ? Colors.white : Colors.black87,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Message Input
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0095F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                hintText: 'Message...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _handleSend(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic_none,
                                color: Colors.black54, size: 22),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.image_outlined,
                                color: Colors.black54, size: 22),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send,
                        color: Color(0xFF0095F6), size: 24),
                    onPressed: _handleSend,
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
