/// Colony User Model
class UserModel {
  final String id;
  final String phone;
  final String? username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final String tier;
  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeen;
  final double? latitude;
  final double? longitude;
  final String? geohash;
  final int coinBalance;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.phone,
    this.username,
    this.displayName = '',
    this.avatarUrl,
    this.bio,
    this.tier = 'free',
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeen,
    this.latitude,
    this.longitude,
    this.geohash,
    this.coinBalance = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        username: json['username'] as String?,
        displayName: json['displayName'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String?,
        bio: json['bio'] as String?,
        tier: json['tier'] as String? ?? 'free',
        isVerified: json['isVerified'] as bool? ?? false,
        isOnline: json['isOnline'] as bool? ?? false,
        lastSeen: json['lastSeen'] != null
            ? DateTime.tryParse(json['lastSeen'] as String)
            : null,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        geohash: json['geohash'] as String?,
        coinBalance: json['coinBalance'] as int? ?? 0,
        followersCount: json['followersCount'] as int? ?? 0,
        followingCount: json['followingCount'] as int? ?? 0,
        postsCount: json['postsCount'] as int? ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'username': username,
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'bio': bio,
        'tier': tier,
        'isVerified': isVerified,
        'isOnline': isOnline,
        'lastSeen': lastSeen?.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'geohash': geohash,
        'coinBalance': coinBalance,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'postsCount': postsCount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
