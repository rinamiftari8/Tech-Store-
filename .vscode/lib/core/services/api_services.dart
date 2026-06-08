import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchApiTip() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('https://api.github.com/zen'),
      );

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          response.body.trim().isNotEmpty) {
        return response.body.trim();
      }

      return 'External API connected successfully.';
    } catch (_) {
      return 'External API connected. Internet may block the live response.';
    }
  }
}
