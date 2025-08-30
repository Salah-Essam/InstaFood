abstract class AppValidator {
  bool _isValid = false;

  bool get isValid => _isValid;

  String _value = '';

  String get value => _value;

  List<String> reasons = [];

  AppValidator({String? initValue}) {
    if (initValue != null) {}
  }
  void setValue(String val) {
    _value = val;
    if (val.isEmpty) {
      _isValid = false;
      reasons.clear();
      return;
    }
    reasons = check();

    if (reasons.isEmpty) {
      _isValid = true;
    } else {
      _isValid = false;
    }
  }

  List<String> check();
}