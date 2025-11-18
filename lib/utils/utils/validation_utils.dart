// lib/src/validation_utils.dart
class ValidationUtils {
  ValidationUtils._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@"
    r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$",
  );

  static bool isValidEmail(String? email) => email != null && _emailRegExp.hasMatch(email.trim());

  static bool isValidPassword(String? password, {int minLength = 6}) =>
      password != null && password.length >= minLength;

  static bool isValidPhone(String? phone) {
    if (phone == null) return false;
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  static bool isValidOtp(String? otp, {int length = 6}) =>
      otp != null && RegExp(r'^\d+\$').hasMatch(otp) && otp.length == length;

  static bool isStrongPassword(String? password) {
    if (password == null) return false;
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}\$').hasMatch(password);
  }

  static bool isNumeric(String? s) => s != null && double.tryParse(s) != null;

  static bool isValidUrl(String? s) {
    if (s == null) return false;
    final uri = Uri.tryParse(s);
    return uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
