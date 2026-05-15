import '../../services/java_api_service.dart';
import '../../services/python_api_service.dart';
import '../network/api_client.dart';
import '../network/api_environment.dart';

class AppServices {
  AppServices._({
    required this.environment,
    required this.pythonApi,
    required this.javaApi,
    required ApiClient pythonClient,
    required ApiClient javaClient,
  }) : _pythonClient = pythonClient,
       _javaClient = javaClient;

  final ApiEnvironment environment;
  final PythonApiService pythonApi;
  final JavaApiService javaApi;
  final ApiClient _pythonClient;
  final ApiClient _javaClient;

  factory AppServices.fromEnvironment() {
    final environment = ApiEnvironment.fromDartDefine();
    return AppServices.fromConfig(environment);
  }

  factory AppServices.fromConfig(ApiEnvironment environment) {
    final pythonClient = ApiClient(
      baseUrl: environment.pythonBaseUrl,
      backendName: 'python',
      timeout: environment.requestTimeout,
    );
    final javaClient = ApiClient(
      baseUrl: environment.javaBaseUrl,
      backendName: 'java',
      timeout: environment.requestTimeout,
    );

    return AppServices._(
      environment: environment,
      pythonApi: PythonApiService(pythonClient),
      javaApi: JavaApiService(javaClient),
      pythonClient: pythonClient,
      javaClient: javaClient,
    );
  }

  void dispose() {
    _pythonClient.close();
    _javaClient.close();
  }
}
