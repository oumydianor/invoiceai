import 'package:flutter_test/flutter_test.dart';
import 'package:invoiceai/core/validators/input_validators.dart';

void main() {
  group('InputValidators', () {
    test('validates an email address', () {
      expect(InputValidators.isEmailValid('person@example.com'), isTrue);
      expect(InputValidators.isEmailValid('person@invalid'), isFalse);
    });

    test('enforces the documented password policy', () {
      expect(InputValidators.isPasswordValid('Strong!Pass1'), isTrue);
      expect(InputValidators.isPasswordValid('weak'), isFalse);
    });

    test('validates E.164 phone numbers and six-digit OTPs', () {
      expect(InputValidators.isPhoneValid('+221771234567'), isTrue);
      expect(InputValidators.isPhoneValid('0771234567'), isFalse);
      expect(InputValidators.isOtpValid('123456'), isTrue);
      expect(InputValidators.isOtpValid('12345a'), isFalse);
    });

    test('requires at least two meaningful name parts', () {
      expect(InputValidators.isFullNameValid('Awa Diop'), isTrue);
      expect(InputValidators.isFullNameValid('Awa'), isFalse);
    });
  });
}
