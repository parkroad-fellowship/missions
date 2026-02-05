/// Input validation utilities.
class InputValidators {
  // Private constructor to prevent instantiation
  InputValidators._();

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validate phone number format (basic)
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{7,15}$').hasMatch(phone);
  }
}
