class ApiEnvironment {
  const ApiEnvironment({
    required this.pythonBaseUrl,
    required this.javaBaseUrl,
    required this.requestTimeout,
  });

  final String pythonBaseUrl;
  final String javaBaseUrl;
  final Duration requestTimeout;

  factory ApiEnvironment.fromDartDefine() {
    final timeoutSeconds =
        int.tryParse(
          const String.fromEnvironment(
            'API_TIMEOUT_SECONDS',
            defaultValue: '20',
          ),
        ) ??
        20;

    return ApiEnvironment(
      pythonBaseUrl: _normalizeBaseUrl(
        const String.fromEnvironment(
          'PYTHON_API_BASE_URL',
          defaultValue: 'http://127.0.0.1:8000',
        ),
      ),
      javaBaseUrl: _normalizeBaseUrl(
        const String.fromEnvironment(
          'JAVA_API_BASE_URL',
          defaultValue: 'http://127.0.0.1:8000',
        ),
      ),
      requestTimeout: Duration(seconds: timeoutSeconds),
    );
  }

  static String _normalizeBaseUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(
        rawUrl,
        'rawUrl',
        'A URL base da API nao pode ser vazia.',
      );
    }

    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }

    return trimmed;
  }
}
