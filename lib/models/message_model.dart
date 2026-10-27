import 'user_model.dart';

class DirectMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  DirectMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });

  factory DirectMessage.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final senderId = json['senderId']?.toString() ?? json['sender_id']?.toString() ?? '';
    final isMe = json['isMe'] == true || (currentUserId != null && senderId == currentUserId);

    DateTime time = DateTime.now();
    if (json['timestamp'] != null) {
      try {
        time = DateTime.parse(json['timestamp'].toString());
      } catch (_) {}
    }

    return DirectMessage(
      id: json['id']?.toString() ?? '',
      senderId: senderId,
      text: json['text']?.toString() ?? '',
      timestamp: time,
      isMe: isMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }
}

class ChatThread {
  final String id;
  final User peer;
  final List<DirectMessage> messages;
  final bool hasUnread;
  final String lastActive;

  ChatThread({
    required this.id,
    required this.peer,
    required this.messages,
    this.hasUnread = false,
    required this.lastActive,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final peerJson = json['peer'];
    final peer = peerJson is Map<String, dynamic>
        ? User.fromJson(peerJson)
        : User(
            id: 'u',
            username: 'User',
            fullName: 'User',
            avatarUrl: '',
          );

    final rawMsgs = json['messages'];
    List<DirectMessage> parsed = [];
    if (rawMsgs is List) {
      parsed = rawMsgs
          .whereType<Map<String, dynamic>>()
          .map((m) => DirectMessage.fromJson(m, currentUserId: currentUserId))
          .toList();
    }

    return ChatThread(
      id: json['id']?.toString() ?? '',
      peer: peer,
      messages: parsed,
      hasUnread: json['hasUnread'] == true || json['has_unread'] == true,
      lastActive: json['lastActive']?.toString() ?? 'Active now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peer': peer.toJson(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'hasUnread': hasUnread,
      'lastActive': lastActive,
    };
  }

  DirectMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;
}
