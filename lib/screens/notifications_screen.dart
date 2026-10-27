import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../state/instagram_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Set<String> _followingIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InstagramScope.of(context).clearNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'This Week',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(MockData.suggestedUsers[0].avatarUrl),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: MockData.suggestedUsers[0].username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const TextSpan(
                    text: ' liked your photo. ',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                  TextSpan(
                    text: '2d',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                MockData.getPosts()[1].imageUrls.first,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(MockData.suggestedUsers[1].avatarUrl),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: MockData.suggestedUsers[1].username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const TextSpan(
                    text: ' started following you. ',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                  TextSpan(
                    text: '3d',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            trailing: OutlinedButton(
              onPressed: () {
                setState(() {
                  final id = MockData.suggestedUsers[1].id;
                  if (_followingIds.contains(id)) {
                    _followingIds.remove(id);
                  } else {
                    _followingIds.add(id);
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: _followingIds.contains(MockData.suggestedUsers[1].id)
                    ? Colors.white
                    : const Color(0xFF0095F6),
                side: BorderSide(
                  color: _followingIds.contains(MockData.suggestedUsers[1].id)
                      ? Colors.grey.shade300
                      : const Color(0xFF0095F6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _followingIds.contains(MockData.suggestedUsers[1].id)
                    ? 'Following'
                    : 'Follow',
                style: TextStyle(
                  color: _followingIds.contains(MockData.suggestedUsers[1].id)
                      ? Colors.black87
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          const Divider(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Earlier',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(MockData.suggestedUsers[2].avatarUrl),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: MockData.suggestedUsers[2].username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  const TextSpan(
                    text: ' mentioned you in a comment: "Super clean!" ',
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                  TextSpan(
                    text: '1w',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                MockData.getPosts()[1].imageUrls.first,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
