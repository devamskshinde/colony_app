/// Group Model
class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final String creatorId;
  final int memberCount;
  final List<String> memberIds;
  final bool isJoined;
  final bool isPublic;
  final String? geohash;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GroupModel({
    required this.id,
    this.name = '',
    this.description,
    this.avatarUrl,
    required this.creatorId,
    this.memberCount = 0,
    this.memberIds = const [],
    this.isJoined = false,
    this.isPublic = false,
    this.geohash,
    this.latitude,
    this.longitude,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        creatorId: json['creatorId'] as String? ?? '',
        memberCount: json['memberCount'] as int? ?? 0,
        memberIds: (json['memberIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        isJoined: json['isJoined'] as bool? ?? false,
        isPublic: json['isPublic'] as bool? ?? false,
        geohash: json['geohash'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        tags: (json['tags'] as List<dynamic>?)
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
        'name': name,
        'description': description,
        'avatarUrl': avatarUrl,
        'creatorId': creatorId,
        'memberCount': memberCount,
        'memberIds': memberIds,
        'isJoined': isJoined,
        'isPublic': isPublic,
        'geohash': geohash,
        'latitude': latitude,
        'longitude': longitude,
        'tags': tags,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
