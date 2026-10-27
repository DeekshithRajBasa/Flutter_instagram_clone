import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/instagram_state.dart';
import 'chat_conversation_screen.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = InstagramScope.of(context);
    final threads = state.chatThreads;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              state.currentUser.username,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call_outlined,
                color: Colors.black87, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_square,
                color: Colors.black87, size: 23),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                  hintText: 'Search messages',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),

          // Active Notes Bar (Instagram Notes feature)
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Current user's note
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                NetworkImage(state.currentUser.avatarUrl),
                          ),
                          Positioned(
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Coding Flutter 💻',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0095F6),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.add,
                                  size: 11, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your note',
                        style: TextStyle(fontSize: 11.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Suggested friends notes
                ...MockData.suggestedUsers.map((u) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(u.avatarUrl),
                            ),
                            Positioned(
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Listening 🎵',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 64,
                          child: Text(
                            u.username,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 11.5, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Messages header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Requests (1)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0095F6),
                  ),
                ),
              ],
            ),
          ),

          // Threads List
          ...threads.map((thread) {
            final lastMsg = thread.lastMessage;
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundImage: NetworkImage(thread.peer.avatarUrl),
                  ),
                  if (thread.hasUnread)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0095F6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                thread.peer.fullName,
                style: TextStyle(
                  fontWeight:
                      thread.hasUnread ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
              subtitle: Text(
                lastMsg != null
                    ? (lastMsg.isMe ? 'You: ${lastMsg.text}' : lastMsg.text)
                    : thread.lastActive,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: thread.hasUnread ? Colors.black87 : Colors.grey.shade600,
                  fontWeight:
                      thread.hasUnread ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Colors.grey, size: 22),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatConversationScreen(thread: thread),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
