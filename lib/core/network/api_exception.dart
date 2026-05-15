class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, required this.backend});

  final String message;
  final int? statusCode;
  final String backend;

  @override
  String toString() {
    if (statusCode == null) {
      return 'ApiException($backend): $message';
    }
    return 'ApiException($backend | HTTP $statusCode): $message';
  }
}
