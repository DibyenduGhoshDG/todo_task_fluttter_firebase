import 'package:shared_preferences/shared_preferences.dart';

class SharePreferenceInstance {
  static SharedPreferences? prefs;

  static final SharePreferenceInstance sharedPrefes =
      SharePreferenceInstance._internal();

  SharePreferenceInstance._internal();

  factory SharePreferenceInstance() {
    return sharedPrefes;
  }

  //shared pref initialize
  init() async {
    await SharedPreferences.getInstance()
        .then((value) => prefs = value)
        .catchError((e) {
      print("Got error: ${e.error}");
    });
  }

  void clear() {
    prefs?.clear();
  }

  //keys
  final USER_TOKEN = 'user_token';
  final INIT_SCREEN = 'initScreen';

  // setUserId
  void setUserId(userId) => prefs?.setString(USER_TOKEN, userId);
  String? getUserId() => prefs?.getString(USER_TOKEN);

  // setLoggedIn
  void setLoggedIn(bool value) => prefs?.setBool(INIT_SCREEN, value);
  bool? isLoggedIn() => prefs?.getBool(INIT_SCREEN);
}

SharePreferenceInstance sharePrefereceInstance = SharePreferenceInstance();
