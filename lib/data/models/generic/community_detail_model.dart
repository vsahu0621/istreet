class CommunityDetail {
  final int id;
  final String name;
  final String description;
  final String creator;
  final bool isCreator;
  final bool canSendMessages;
  final int membersCount;
  final int messagesCount;
  final List<Member> members;
  final List<Message> messages;

  CommunityDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.creator,
    required this.isCreator,
    required this.canSendMessages,
    required this.membersCount,
    required this.messagesCount,
    required this.members,
    required this.messages,
  });

  factory CommunityDetail.fromJson(Map<String, dynamic> json) {
    return CommunityDetail(
      id: json['community']['id'],
      name: json['community']['name'],
      description: json['community']['description'],
      creator: json['community']['creator'],
      isCreator: json['is_creator'],
      canSendMessages: json['can_send_messages'],
      membersCount: json['members_count'],
      messagesCount: json['messages_count'],
      members: (json['members'] as List)
          .map((e) => Member.fromJson(e))
          .toList(),
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }
}

class Member {
  final String name;
  final String role;

  Member({required this.name, required this.role});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(name: json['name'], role: json['role']);
  }
}

class Message {
  final int id;
  final String text;
  final String type;
  final int? senderId; // ✅ nullable (IMPORTANT)

  final String sender;

  final String createdAt;

  Message({
    required this.id,
    required this.text,
    required this.type,
    this.senderId,
    required this.sender,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      // text: json['text'],
      // type: json['message_type'],
      text: json['text'] ?? json['message'] ?? '',
      type: json['message_type'] ?? json['type'] ?? 'text',
      senderId: json['sender_id'],
      sender: json['sender'] ?? 'Unknown',
      createdAt: json['created_at'] ?? '',
    );
  }
}
