
import 'package:insta_food/core/utils/app_validators.dart';

class DateOfBirthAppValidator extends AppValidator {
  DateOfBirthAppValidator({super.initValue});

  @override
  List<String> check() {
    List<String> errors = [];


    // Check if the value is empty
    if (value.isEmpty) {
      errors.add('Date of birth is required');
      return errors;
    }

    // Parse the date (expecting format: DD/MM/YYYY or DD-MM-YYYY or YYYY-MM-DD)
    DateTime? parsedDate = _parseDate(value);
    
    if (parsedDate == null) {
      errors.add('Invalid date format. Please use DD/MM/YYYY');
      return errors;
    }

    // Check if date is not in the future
    final now = DateTime.now();
    if (parsedDate.isAfter(now)) {
      errors.add('Date of birth cannot be in the future');
      return errors;
    }

    // Check if person is not too old (e.g., more than 150 years)
    final age = now.difference(parsedDate).inDays ~/ 365;
    if (age > 150) {
      errors.add('Please enter a valid date of birth');
      return errors;
    }

    // Check if person is at least 13 years old (minimum age requirement)
    if (age < 13) {
      errors.add('You must be at least 13 years old to register');
      return errors;
    }

    return errors;
  }
  DateTime? _parseDate(String dateString) {
    try {
      dateString = dateString.trim();

      // Pattern: D/M/YYYY or DD/MM/YYYY or D-M-YYYY or DD-MM-YYYY
      final dmY = RegExp(r'^(\d{1,2})[\/-](\d{1,2})[\/-](\d{4})$');

      if (dmY.hasMatch(dateString)) {
        final m = dmY.firstMatch(dateString)!;
        final day = int.parse(m.group(1)!);
        final month = int.parse(m.group(2)!);
        final year = int.parse(m.group(3)!);
        if (!_isValidDate(day, month, year)) return null;
        return DateTime(year, month, day);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  bool _isValidDate(int day, int month, int year) {
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > _getDaysInMonth(month, year)) return false;
    return true;
  }

  /// Returns the number of days in a given month and year
  int _getDaysInMonth(int month, int year) {
    switch (month) {
      case 1: case 3: case 5: case 7: case 8: case 10: case 12:
        return 31;
      case 4: case 6: case 9: case 11:
        return 30;
      case 2:
        // Check for leap year
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
          return 29; // Leap year
        } else {
          return 28; // Regular year
        }
      default:
        return 31; // Default fallback
    }
  }
}