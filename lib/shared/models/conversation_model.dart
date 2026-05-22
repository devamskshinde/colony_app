/// Chat Conversation Model
class ConversationModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final bool otherUserOnline;
  final String? lastMessage;
  final String? lastMessageType;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isMuted;
  final bool isGroup;
  final String? groupName;
  final String? groupAvatar;
  final DateTime? createdAt;

  const ConversationModel({
    required this.id,
    required this.otherUserId,
    this.otherUserName = '',
    this.otherUserAvatar,
    this.otherUserOnline = false,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isGroup = false,
    this.groupName,
    this.groupAvatar,
    this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['id'] as String? ?? '',
        otherUserId: json['otherUserId'] as String? ?? '',
        otherUserName: json['otherUserName'] as String? ?? '',
        otherUserAvatar: json['otherUserAvatar'] as String?,
        otherUserOnline: json['otherUserOnline'] as bool? ?? false,
        lastMessage: json['lastMessage'] as String?,
        lastMessageType: json['lastMessageType'] as String?,
        lastMessageTime: json['lastMessageTime'] != null
            ? DateTime.tryParse(json['lastMessageTime'] as String)
            : null,
        unreadCount: json['unreadCount'] as int? ?? 0,
        isMuted: json['isMuted'] as bool? ?? false,
        isGroup: json['isGroup'] as bool? ?? false,
        groupName: json['groupName'] as String?,
        groupAvatar: json['groupAvatar'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'otherUserAvatar': otherUserAvatar,
        'otherUserOnline': otherUserOnline,
        'lastMessage': lastMessage,
        'lastMessageType': lastMessageType,
        'lastMessageTime': lastMessageTime?.toIso8601String(),
        'unreadCount': unreadCount,
        'isMuted': isMuted,
        'isGroup': isGroup,
        'groupName': groupName,
        'groupAvatar': groupAvatar,
        'createdAt': createdAt?.toIso8601String(),
      };
}
