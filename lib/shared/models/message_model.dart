/// Chat Message Model
class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String type;
  final String? mediaUrl;
  final bool isRead;
  final bool isDelivered;
  final DateTime? readAt;
  final DateTime? createdAt;
  final String? replyToId;
  final String? replyToContent;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content = '',
    this.type = 'text',
    this.mediaUrl,
    this.isRead = false,
    this.isDelivered = false,
    this.readAt,
    this.createdAt,
    this.replyToId,
    this.replyToContent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String? ?? '',
        conversationId: json['conversationId'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        content: json['content'] as String? ?? '',
        type: json['type'] as String? ?? 'text',
        mediaUrl: json['mediaUrl'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        isDelivered: json['isDelivered'] as bool? ?? false,
        readAt: json['readAt'] != null
            ? DateTime.tryParse(json['readAt'] as String)
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        replyToId: json['replyToId'] as String?,
        replyToContent: json['replyToContent'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
        'type': type,
        'mediaUrl': mediaUrl,
        'isRead': isRead,
        'isDelivered': isDelivered,
        'readAt': readAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'replyToId': replyToId,
        'replyToContent': replyToContent,
      };
}
