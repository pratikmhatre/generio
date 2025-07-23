import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsProvider {
  static final SharedPrefsProvider _instance = SharedPrefsProvider._internal();

  SharedPrefsProvider._internal();

  factory SharedPrefsProvider() => _instance;

  SharedPreferences? _prefs;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs ??= await SharedPreferences.getInstance();
  }

  static const _profileInfo = 'profileInfo';

  set profileInfo(String value) {
    _prefs?.setString(_profileInfo, value);
  }

  String get profileInfo => _prefs?.getString(_profileInfo) ?? "";
}
