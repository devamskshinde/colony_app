import '../../../core/network/api_client.dart';

/// User API Service — profile, location, config endpoints
class UserApiService {
  final ApiClient _apiClient;

  UserApiService(this._apiClient);

  // ─── Profile ─────────────────────────────────────────────

  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await _apiClient.get('/users/profile');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/users/profile', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPublicProfile(String userId) async {
    final response = await _apiClient.get('/users/$userId');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> searchUsers(String query) async {
    final response = await _apiClient.get('/users/search', queryParameters: {'q': query});
    return response.data as List<dynamic>;
  }

  // ─── Location ────────────────────────────────────────────

  Future<Map<String, dynamic>> updateLocation(double lat, double lng, {double? accuracy}) async {
    final response = await _apiClient.post('/location/update', data: {
      'latitude': lat,
      'longitude': lng,
      if (accuracy != null) 'accuracy': accuracy,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getNearby({double? radius, int? limit}) async {
    final response = await _apiClient.get('/location/nearby', queryParameters: {
      if (radius != null) 'radius': radius,
      if (limit != null) 'limit': limit,
    });
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getMyLocation() async {
    final response = await _apiClient.get('/location');
    return response.data as Map<String, dynamic>;
  }

  // ─── Config ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getConfig() async {
    final response = await _apiClient.get('/config');
    return response.data as Map<String, dynamic>;
  }

  Future<int> getConfigVersion() async {
    final response = await _apiClient.get('/config/version');
    return response.data['version'] as int? ?? 0;
  }

  Future<Map<String, dynamic>> getFeatureFlags() async {
    final response = await _apiClient.get('/config/features');
    return response.data as Map<String, dynamic>;
  }
}
