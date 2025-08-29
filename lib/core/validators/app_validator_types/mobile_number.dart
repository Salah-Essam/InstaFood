import 'package:insta_food/core/utils/app_validators.dart';

class MobileAppValidator extends AppValidator {
  MobileAppValidator({super.initValue});

  @override
  List<String> check() {
    List<String> errors = [];

    // Check if the value is empty
    if (value.isEmpty) {
      errors.add('Mobile number is required');
      return errors;
    }

    // Remove any spaces, dashes, or brackets from the input
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if the cleaned number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      errors.add('Mobile number must contain only digits');
      return errors;
    }

    // Check length (typically mobile numbers are 7-15 digits)
    if (cleanNumber.length < 7) {
      errors.add('Mobile number is too short (minimum 7 digits)');
      return errors;
    }

    if (cleanNumber.length > 15) {
      errors.add('Mobile number is too long (maximum 15 digits)');
      return errors;
    }

    return errors;
  }
}
