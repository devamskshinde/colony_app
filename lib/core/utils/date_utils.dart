import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Date & Time Utilities
/// Formatting and relative time helpers
class ColonyDateUtils {
  ColonyDateUtils._();

  static void init() {
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  }

  /// "2m ago", "3h ago", "Yesterday"
  static String timeAgo(DateTime dateTime) {
    return timeago.format(dateTime, allowFromNow: true);
  }

  /// "2 min ago" (more readable)
  static String timeAgoFull(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return DateFormat('MMM d').format(dateTime);
  }

  /// "10:30 AM"
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// "Today", "Yesterday", "Mon", "Jan 5"
  static String formatChatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (now.difference(date).inDays < 7) return DateFormat('EEEE').format(dateTime);
    return DateFormat('MMM d').format(dateTime);
  }

  /// "May 22, 2026"
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, y').format(dateTime);
  }

  /// "22 May 2026"
  static String formatDateLong(DateTime dateTime) {
    return DateFormat('d MMMM y').format(dateTime);
  }

  /// "May 2026"
  static String formatMonth(DateTime dateTime) {
    return DateFormat('MMMM y').format(dateTime);
  }

  /// Calculate age from date of birth
  static int calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is within last 24 hours
  static bool isWithin24Hours(DateTime date) {
    return DateTime.now().difference(date).inHours < 24;
  }

  /// Story time remaining text
  static String storyTimeRemaining(DateTime createdAt) {
    final expires = createdAt.add(const Duration(hours: 24));
    final remaining = expires.difference(DateTime.now());
    if (remaining.isNegative) return 'Expired';
    if (remaining.inHours > 0) return '${remaining.inHours}h left';
    return '${remaining.inMinutes}m left';
  }
}
