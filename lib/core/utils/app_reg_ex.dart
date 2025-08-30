class AppRegExp {
  static RegExp email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static RegExp numbers = RegExp(r'[0-9]');
  static RegExp capitalLetter = RegExp(r'[A-Z]+');
  static RegExp smallLetter = RegExp(r'[a-z]+');
  static RegExp space = RegExp(r'\s');
  static RegExp specialCharacters = RegExp(r'[^\w\s\u0600-\u06FF]');
}