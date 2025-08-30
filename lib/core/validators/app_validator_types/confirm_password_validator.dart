import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/utils/app_validators.dart';

class ConfirmPasswordAppValidator extends AppValidator {
  ConfirmPasswordAppValidator({super.initValue});

  String _comparedWithPassword = "";

  set comparedWithPassword(password) {
    _comparedWithPassword = password;
    setValue(value);
  }

  @override
  List<String> check() {
    List<String> resons = [];

    if (value != _comparedWithPassword) {
      resons.add(AppStrings.passwordDontMatch);
    }

    return resons;
  }
}
