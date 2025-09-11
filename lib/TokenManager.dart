import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> saveIfCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkedIn', "true");
  }

  static Future<void> saveUserInfo(String username, int role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setInt('role', role);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> checkIfCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('checkedIn') == "true";
  }

  static Future<void> deleteCheckOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("checkedIn");
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminName');
  }

  static Future<int?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('role');
  }

  static Future<String?> getSupervisorId() async {
    String? token = await getToken();
    // print("dsdsfsfgsdgfgdfgdfgdf${token}");
    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print(decodedToken);
        // print(decodedToken["id"]);
        return decodedToken["id"];
      } catch (e) {
        print("Error decoding token: $e");
      }
    }
    return null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
