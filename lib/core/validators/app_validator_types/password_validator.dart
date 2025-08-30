import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/utils/app_reg_ex.dart';
import 'package:insta_food/core/utils/app_validators.dart';

class PasswordAppValidator extends AppValidator {
  PasswordAppValidator({super.initValue});

  @override
  List<String> check() {
    List<String> reasons = [];

    if (value.length < 8) {
      reasons.add(AppStrings.passwordMin);
    }

    if (!AppRegExp.smallLetter.hasMatch(value)) {
      reasons.add(AppStrings.mustHaveSmall);
    }

    if (!AppRegExp.capitalLetter.hasMatch(value)) {
      reasons.add(AppStrings.mustHaveCapital);
    }

    if (!AppRegExp.specialCharacters.hasMatch(value)) {
      reasons.add(AppStrings.mustHaveSpecialCharacters);
    }

    if (!AppRegExp.numbers.hasMatch(value)) {
      reasons.add(AppStrings.mustHaveNumber);
    }

    if (AppRegExp.space.hasMatch(value)) {
      reasons.add(AppStrings.passwordHasNoSpaces);
    }

    return reasons;
  }
}
