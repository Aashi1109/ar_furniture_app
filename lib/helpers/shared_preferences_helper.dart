import 'package:shared_preferences/shared_preferences.dart';

/// Helpers related to SharedPreferences
class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get preferences async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }
}
