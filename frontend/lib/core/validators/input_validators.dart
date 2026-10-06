abstract final class InputValidators {
  static final RegExp _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$",
  );
  static final RegExp _e164Pattern = RegExp(r'^\+[1-9]\d{7,14}$');
  static final RegExp _otpPattern = RegExp(r'^\d{6}$');

  static bool isEmailValid(String value) =>
      _emailPattern.hasMatch(value.trim());

  /// At least 12 characters, with lower/upper case, a digit and a symbol.
  static bool isPasswordValid(String value) =>
      value.length >= 12 &&
      value.contains(RegExp('[a-z]')) &&
      value.contains(RegExp('[A-Z]')) &&
      value.contains(RegExp(r'\d')) &&
      value.contains(RegExp(r'[^A-Za-z0-9]'));

  static bool doPasswordsMatch(String password, String confirmation) =>
      password == confirmation;

  static bool isPhoneValid(String value) => _e164Pattern.hasMatch(value.trim());

  static bool isOtpValid(String value) => _otpPattern.hasMatch(value.trim());

  static bool isFullNameValid(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts.length >= 2 && parts.every((part) => part.length >= 2);
  }
}
