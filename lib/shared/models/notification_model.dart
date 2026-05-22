/// Notification Model
class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? imageUrl;
  final String? actionUrl;
  final String? senderId;
  final String? senderName;
  final String? senderAvatar;
  final bool isRead;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    this.title = '',
    this.body = '',
    this.imageUrl,
    this.actionUrl,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.isRead = false,
    this.metadata,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        imageUrl: json['imageUrl'] as String?,
        actionUrl: json['actionUrl'] as String?,
        senderId: json['senderId'] as String?,
        senderName: json['senderName'] as String?,
        senderAvatar: json['senderAvatar'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        metadata: json['metadata'] as Map<String, dynamic>?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'body': body,
        'imageUrl': imageUrl,
        'actionUrl': actionUrl,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'isRead': isRead,
        'metadata': metadata,
        'createdAt': createdAt?.toIso8601String(),
      };
}
