import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../core/utils/geohash_utils.dart';
import '../core/errors/app_exceptions.dart';

/// Location Service
/// Handles GPS positioning and location updates
class LocationService {
  Position? _lastPosition;
  final _locationController = StreamController<Position>.broadcast();

  Stream<Position> get locationStream => _locationController.stream;
  Position? get lastPosition => _lastPosition;

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current location
  Future<Position> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw const LocationException(message: 'Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _lastPosition = position;
      _locationController.add(position);
      return position;
    } catch (e) {
      if (e is AppException) rethrow;
      throw const LocationException(message: 'Failed to get location');
    }
  }

  /// Get geohash for current location
  Future<String> getCurrentGeohash({int precision = 6}) async {
    final position = await getCurrentLocation();
    return GeohashUtils.encode(
      position.latitude,
      position.longitude,
      precision: precision,
    );
  }

  /// Start listening to location changes
  StreamSubscription<Position> startLocationUpdates({
    int distanceFilterMeters = 50,
    void Function(Position)? onUpdate,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    ).listen((position) {
      _lastPosition = position;
      _locationController.add(position);
      onUpdate?.call(position);
    });
  }

  /// Calculate distance between two points
  double distanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void dispose() {
    _locationController.close();
  }
}
