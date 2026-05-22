/// Colony Post Model
class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final List<String> mediaUrls;
  final String mediaType;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isSaved;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String> hashtags;
  final List<String> mentions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostModel({
    required this.id,
    required this.userId,
    this.userName = '',
    this.userAvatar,
    this.content = '',
    this.mediaUrls = const [],
    this.mediaType = 'image',
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.location,
    this.latitude,
    this.longitude,
    this.hashtags = const [],
    this.mentions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        userName: json['userName'] as String? ?? '',
        userAvatar: json['userAvatar'] as String?,
        content: json['content'] as String? ?? '',
        mediaUrls: (json['mediaUrls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        mediaType: json['mediaType'] as String? ?? 'image',
        likesCount: json['likesCount'] as int? ?? 0,
        commentsCount: json['commentsCount'] as int? ?? 0,
        sharesCount: json['sharesCount'] as int? ?? 0,
        isLiked: json['isLiked'] as bool? ?? false,
        isSaved: json['isSaved'] as bool? ?? false,
        location: json['location'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        hashtags: (json['hashtags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        mentions: (json['mentions'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'content': content,
        'mediaUrls': mediaUrls,
        'mediaType': mediaType,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'sharesCount': sharesCount,
        'isLiked': isLiked,
        'isSaved': isSaved,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'hashtags': hashtags,
        'mentions': mentions,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
