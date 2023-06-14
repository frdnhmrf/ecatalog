import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasource {
  Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }

  Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }
}
