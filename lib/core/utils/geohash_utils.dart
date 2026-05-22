import 'dart:math';

/// Geohash Utilities
/// Encode/decode geohashes for location-based features
class GeohashUtils {
  GeohashUtils._();

  static const String _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  /// Encode latitude/longitude to geohash string
  static String encode(double latitude, double longitude, {int precision = 6}) {
    double minLat = -90, maxLat = 90;
    double minLng = -180, maxLng = 180;
    bool isEven = true;
    int bit = 0;
    int ch = 0;
    final StringBuffer geohash = StringBuffer();

    while (geohash.length < precision) {
      if (isEven) {
        final mid = (minLng + maxLng) / 2;
        if (longitude > mid) {
          ch |= 1 << (4 - bit);
          minLng = mid;
        } else {
          maxLng = mid;
        }
      } else {
        final mid = (minLat + maxLat) / 2;
        if (latitude > mid) {
          ch |= 1 << (4 - bit);
          minLat = mid;
        } else {
          maxLat = mid;
        }
      }
      isEven = !isEven;
      if (bit < 4) {
        bit++;
      } else {
        geohash.write(_base32[ch]);
        bit = 0;
        ch = 0;
      }
    }
    return geohash.toString();
  }

  /// Decode geohash string to latitude/longitude center
  static (double lat, double lng) decode(String geohash) {
    double minLat = -90, maxLat = 90;
    double minLng = -180, maxLng = 180;
    bool isEven = true;

    for (int i = 0; i < geohash.length; i++) {
      final idx = _base32.indexOf(geohash[i]);
      for (int j = 4; j >= 0; j--) {
        final bit = (idx >> j) & 1;
        if (isEven) {
          final mid = (minLng + maxLng) / 2;
          if (bit == 1) {
            minLng = mid;
          } else {
            maxLng = mid;
          }
        } else {
          final mid = (minLat + maxLat) / 2;
          if (bit == 1) {
            minLat = mid;
          } else {
            maxLat = mid;
          }
        }
        isEven = !isEven;
      }
    }
    return ((minLat + maxLat) / 2, (minLng + maxLng) / 2);
  }

  /// Get neighboring geohashes (8 surrounding cells)
  static List<String> neighbors(String geohash) {
    final (lat, lng) = decode(geohash);
    final prec = geohash.length;
    // Approximate degree offsets for precision
    final offset = _precisionToOffset(prec);

    return [
      encode(lat + offset, lng - offset, precision: prec), // top-left
      encode(lat + offset, lng, precision: prec), // top
      encode(lat + offset, lng + offset, precision: prec), // top-right
      encode(lat, lng - offset, precision: prec), // left
      encode(lat, lng + offset, precision: prec), // right
      encode(lat - offset, lng - offset, precision: prec), // bottom-left
      encode(lat - offset, lng, precision: prec), // bottom
      encode(lat - offset, lng + offset, precision: prec), // bottom-right
    ];
  }

  static double _precisionToOffset(int precision) {
    switch (precision) {
      case 1: return 22.5;
      case 2: return 5.625;
      case 3: return 0.703125;
      case 4: return 0.087890625;
      case 5: return 0.010986328125;
      case 6: return 0.001373291015625;
      case 7: return 0.000171661376953125;
      default: return 0.001373291015625;
    }
  }

  /// Calculate distance between two points in km (Haversine)
  static double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const earthRadius = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRad(double deg) => deg * pi / 180;

  /// Format distance for display
  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()}m';
    if (km < 10) return '${km.toStringAsFixed(1)}km';
    return '${km.round()}km';
  }
}
