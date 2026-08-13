import 'package:flutter_test/flutter_test.dart';
import 'package:invoiceai/core/utils/phone_number_normalizer.dart';

void main() {
  test('normalizes a national number to E.164', () {
    expect(
      PhoneNumberNormalizer.normalize('+221', '077 123 45 67'),
      '+221771234567',
    );
  });
}
