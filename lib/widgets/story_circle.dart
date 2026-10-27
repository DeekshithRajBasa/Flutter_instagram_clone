import 'package:flutter/material.dart';
import '../models/story_model.dart';

class StoryCircle extends StatelessWidget {
  final UserStory userStory;
  final bool isCurrentUser;
  final VoidCallback onTap;

  const StoryCircle({
    super.key,
    required this.userStory,
    this.isCurrentUser = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const instagramGradient = LinearGradient(
      colors: [
        Color(0xFFFBAA47),
        Color(0xFFD91A46),
        Color(0xFFA60F93),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Gradient or Grey Border
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: userStory.isSeen || isCurrentUser
                        ? null
                        : instagramGradient,
                    color: userStory.isSeen ? Colors.grey.shade400 : null,
                  ),
                ),
                // White inner gap
                Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                // Avatar Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: userStory.user.avatarUrl.isNotEmpty
                      ? Image.network(
                          userStory.user.avatarUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFF0095F6),
                          child: Center(
                            child: Text(
                              userStory.user.username.isNotEmpty
                                  ? userStory.user.username[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                ),
                // Plus icon for current user
                if (isCurrentUser)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0095F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 74,
              child: Text(
                isCurrentUser ? 'Your story' : userStory.user.username,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
