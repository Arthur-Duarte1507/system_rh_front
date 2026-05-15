import '../core/network/api_client.dart';

class PythonApiService {
  const PythonApiService(this._client);

  final ApiClient _client;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _client.get(
      path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _client.post(
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _client.put(
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _client.delete(
      path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<bool> healthCheck() async {
    await _client.get('/health');
    return true;
  }
}
