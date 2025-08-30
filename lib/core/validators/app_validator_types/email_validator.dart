import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/utils/app_reg_ex.dart';
import 'package:insta_food/core/utils/app_validators.dart';

class EmailAppValidator extends AppValidator {
  EmailAppValidator({super.initValue});
  @override
  List<String> check() {
    List<String> reasons = [];

    if (value.isEmpty) {
      reasons.add(AppStrings.emailIsValid);
    }
    if (!AppRegExp.email.hasMatch(value)) {
      reasons.add(AppStrings.emailNotValid);
    }
    return reasons;
  }
}
