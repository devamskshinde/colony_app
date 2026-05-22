/// Story Model
class StoryModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String mediaType;
  final String? mediaUrl;
  final String? caption;
  final int viewsCount;
  final bool isViewed;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  const StoryModel({
    required this.id,
    required this.userId,
    this.userName = '',
    this.userAvatar,
    this.mediaType = 'image',
    this.mediaUrl,
    this.caption,
    this.viewsCount = 0,
    this.isViewed = false,
    this.createdAt,
    this.expiresAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        userName: json['userName'] as String? ?? '',
        userAvatar: json['userAvatar'] as String?,
        mediaType: json['mediaType'] as String? ?? 'image',
        mediaUrl: json['mediaUrl'] as String?,
        caption: json['caption'] as String?,
        viewsCount: json['viewsCount'] as int? ?? 0,
        isViewed: json['isViewed'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        expiresAt: json['expiresAt'] != null
            ? DateTime.tryParse(json['expiresAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'mediaType': mediaType,
        'mediaUrl': mediaUrl,
        'caption': caption,
        'viewsCount': viewsCount,
        'isViewed': isViewed,
        'createdAt': createdAt?.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
      };
}
