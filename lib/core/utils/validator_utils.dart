import '../constants/app_constants.dart';

/// Input Validators
/// Form validation utilities
class ValidatorUtils {
  ValidatorUtils._();

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(AppConstants.phoneRegex).hasMatch(cleaned)) {
      return 'Enter a valid 10-digit Indian phone number';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (!RegExp(AppConstants.otpRegex).hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    final cleaned = value.trim().toLowerCase();
    if (cleaned.length < AppConstants.minUsernameLength) {
      return 'At least ${AppConstants.minUsernameLength} characters';
    }
    if (cleaned.length > AppConstants.maxUsernameLength) {
      return 'Max ${AppConstants.maxUsernameLength} characters';
    }
    if (!RegExp(AppConstants.usernameRegex).hasMatch(cleaned)) {
      return 'Only lowercase letters, numbers, and _';
    }
    return null;
  }

  static String? validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.trim().length > AppConstants.maxDisplayNameLength) {
      return 'Max ${AppConstants.maxDisplayNameLength} characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(AppConstants.emailRegex).hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value != null && value.length > AppConstants.maxBioLength) {
      return 'Max ${AppConstants.maxBioLength} characters';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int min, String fieldName) {
    if (value == null || value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phoneRegex)
        .hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  static bool isValidUsername(String username) {
    return RegExp(AppConstants.usernameRegex)
        .hasMatch(username.trim().toLowerCase());
  }

  static String? validateGroupName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Group name is required';
    }
    if (value.trim().length > AppConstants.maxGroupNameLength) {
      return 'Max ${AppConstants.maxGroupNameLength} characters';
    }
    return null;
  }

  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    if (value.length > AppConstants.maxMessageLength) {
      return 'Max ${AppConstants.maxMessageLength} characters';
    }
    return null;
  }
}
