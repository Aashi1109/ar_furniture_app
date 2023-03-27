import 'package:http/http.dart' as http;

class HttpHelper {
  static const rtdbBaseUrl = 'https://decal-9b680-default-rtdb.firebaseio.com/';
  static const rtdbOrdersUrl = '${rtdbBaseUrl}orders.json';
  static const rtdbProductsUrl = '${rtdbBaseUrl}products.json';
  static const rtdbUsersUrl = '${rtdbBaseUrl}users.json';
  static const rtdbCartUrl = '${rtdbBaseUrl}cart.json';

  static Future<http.Response> get(String url) async {
    return await http.get(Uri.parse(url));
  }
}
