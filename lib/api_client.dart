import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiError implements Exception {
  final String msg;
  ApiError(this.msg);
}

class ApiClient {
  final http.Client client;
  ApiClient(this.client);

  Future<Map<String, dynamic>> getLatest(String base) async {
    http.Response resp;
    try {
      resp = await client
          .get(Uri.parse('https://open.er-api.com/v6/latest/$base'))
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw ApiError('Нет подключения к интернету');
    }

    if (resp.statusCode != 200) {
      throw ApiError('Ошибка сервера (${resp.statusCode})');
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(resp.body);
    } catch (e) {
      throw ApiError('Некорректный ответ сервера');
    }
    // при ошибке апи всё равно отдаёт 200, но result = error
    if (data['result'] != 'success') {
      throw ApiError('Сервер вернул ошибку: ${data['error-type']}');
    }
    return data;
  }
}
