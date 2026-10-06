abstract final class PhoneNumberNormalizer {
  static String normalize(String countryCode, String nationalNumber) {
    final prefix = countryCode.replaceAll(RegExp(r'[^\d+]'), '');
    var number = nationalNumber.replaceAll(RegExp(r'\D'), '');
    number = number.replaceFirst(RegExp(r'^0+'), '');
    final normalizedPrefix = prefix.startsWith('+') ? prefix : '+$prefix';
    return '$normalizedPrefix$number';
  }
}
