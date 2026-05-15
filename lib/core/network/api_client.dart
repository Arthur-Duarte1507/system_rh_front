import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.backendName,
    required this.timeout,
    http.Client? httpClient,
    Map<String, String>? defaultHeaders,
  }) : _httpClient = httpClient ?? http.Client(),
       _defaultHeaders = <String, String>{
         HttpHeaders.contentTypeHeader: 'application/json',
         HttpHeaders.acceptHeader: 'application/json',
         ...?defaultHeaders,
       };

  final String baseUrl;
  final String backendName;
  final Duration timeout;
  final http.Client _httpClient;
  final Map<String, String> _defaultHeaders;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _send(
      () => _httpClient.get(
        _buildUri(path, queryParameters),
        headers: _mergeHeaders(headers),
      ),
    );
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _send(
      () => _httpClient.post(
        _buildUri(path, queryParameters),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _send(
      () => _httpClient.put(
        _buildUri(path, queryParameters),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _send(
      () => _httpClient.delete(
        _buildUri(path, queryParameters),
        headers: _mergeHeaders(headers),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  void close() {
    _httpClient.close();
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$baseUrl$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, '$value'),
      ),
    );
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {..._defaultHeaders, ...?headers};
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(timeout);
      return _parseResponse(response);
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de requisicao excedido.',
        backend: backendName,
      );
    } on SocketException catch (error) {
      throw ApiException(
        message: 'Falha de conexao com a API: ${error.message}',
        backend: backendName,
      );
    } on FormatException {
      throw ApiException(
        message: 'Resposta da API em formato invalido.',
        backend: backendName,
      );
    }
  }

  dynamic _parseResponse(http.Response response) {
    final body = response.body.trim();
    final parsedBody = body.isEmpty ? null : _decodeBody(body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return parsedBody;
    }

    throw ApiException(
      message: _extractErrorMessage(parsedBody),
      statusCode: response.statusCode,
      backend: backendName,
    );
  }

  dynamic _decodeBody(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }

  String _extractErrorMessage(dynamic parsedBody) {
    if (parsedBody is Map<String, dynamic>) {
      final message =
          parsedBody['message'] ??
          parsedBody['error'] ??
          parsedBody['detail'] ??
          parsedBody['errors'];
      if (message != null) {
        return '$message';
      }
    }

    if (parsedBody is String && parsedBody.isNotEmpty) {
      return parsedBody;
    }

    return 'Erro nao mapeado retornado pela API.';
  }
}
