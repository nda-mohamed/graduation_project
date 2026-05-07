import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";
  static const String apiKey = "agrinova-key-7f3a9b2c1d4e5f6a";

  static Future<String> askAI(String prompt) async {
    final url = Uri.parse("$baseUrl/ask?prompt=$prompt");

    final response = await http.post(
      url,
      headers: {
        "X-API-Key": apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["answer"] ?? response.body;
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}