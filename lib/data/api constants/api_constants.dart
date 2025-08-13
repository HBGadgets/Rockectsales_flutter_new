import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://rocketsales-server.onrender.com';
  static String serverUrl = '${dotenv.env['BASE_URL']}';
  static const String register = '$baseUrl/salesman/register';

  static const String login = '$baseUrl/salesman/login';
}
