import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode = 200,
  });
}

class ApiClient {
  static const Duration _timeout = Duration(seconds: 8);

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<ApiResponse<Map<String, dynamic>>> get(String url,
      {Map<String, String>? queryParams}) async {
    try {
      Uri uri = Uri.parse(url);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      dev.log('GET $uri', name: 'ApiClient');
      final response = await http.get(uri, headers: _headers).timeout(_timeout);
      dev.log('Response ${response.statusCode}: ${response.body}', name: 'ApiClient');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse(success: true, data: decoded, statusCode: response.statusCode);
      } else {
        String errMsg = 'Request failed (${response.statusCode})';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['error'] != null) {
            errMsg = decoded['error'].toString();
          }
        } catch (_) {}
        return ApiResponse(success: false, error: errMsg, statusCode: response.statusCode);
      }
    } catch (e) {
      dev.log('API Error on GET $url: $e', name: 'ApiClient');
      return ApiResponse(success: false, error: e.toString(), statusCode: 0);
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      dev.log('POST $uri body: $body', name: 'ApiClient');
      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      dev.log('Response ${response.statusCode}: ${response.body}', name: 'ApiClient');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse(success: true, data: decoded, statusCode: response.statusCode);
      } else {
        String errMsg = 'Request failed (${response.statusCode})';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['error'] != null) {
            errMsg = decoded['error'].toString();
          }
        } catch (_) {}
        return ApiResponse(success: false, error: errMsg, statusCode: response.statusCode);
      }
    } catch (e) {
      dev.log('API Error on POST $url: $e', name: 'ApiClient');
      return ApiResponse(success: false, error: e.toString(), statusCode: 0);
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);
      dev.log('PUT $uri body: $body', name: 'ApiClient');
      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse(success: true, data: decoded, statusCode: response.statusCode);
      } else {
        return ApiResponse(
          success: false,
          error: 'Request failed (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      dev.log('API Error on PUT $url: $e', name: 'ApiClient');
      return ApiResponse(success: false, error: e.toString(), statusCode: 0);
    }
  }
}
