class ApiConstants {
  static const String baseUrl = "https://fakerestaurantapi.runasp.net/api";
  static const String restaurant = "/Restaurant";
  static const String category = '$restaurant?category=';
  static const String addressandname = '$restaurant?address={address}&name={name}';
  static String menu(int id) => '$restaurant/$id/menu';
  static String menuSort(int id) => '$restaurant/$id/menu?sortbyprice={sortbyprice}';
  static const String user = "/User";
  static const String items = "/Restaurant/items";
  static const String itemsearch = "/Restaurant/items?ItemName=";
  static const String itemSort = "/Restaurant/items?sortbyprice=";
}

