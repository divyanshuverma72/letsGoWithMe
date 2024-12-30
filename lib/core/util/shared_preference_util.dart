import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  static SharedPreferenceUtil? _instance;

  SharedPreferenceUtil._();

  static SharedPreferenceUtil get instance =>
      _instance ??= SharedPreferenceUtil._();

  String loginOtp = "login_otp";
  String isNewUser = "is_new_user";
  String mobileNumber = "mobile_number";
  String userId = "user_id";

  String username = "user_name";
  String firstName = "first_name";
  String lastName = "last_name";
  String profileImage = "profile_image";
  String email = "email";
  String dateOfBirth = "dob";
  String gender = "gender";
  String accessToken = "accessToken";

  Future<bool> getBooleanPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  setBooleanPreferencesValue(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  setIntPreferencesValue(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  Future<int> getIntPreferenceValue(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? 0;
  }

  Future<String?> getStringPreferenceValue(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  setStringPreferenceValue(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }
}