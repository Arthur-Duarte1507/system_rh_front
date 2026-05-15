import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistema_rh/app/system_rh_app.dart';
import 'package:sistema_rh/core/di/app_services.dart';
import 'package:sistema_rh/core/network/api_environment.dart';

void main() {
  testWidgets('renderiza a tela de login', (WidgetTester tester) async {
    final services = AppServices.fromConfig(
      const ApiEnvironment(
        pythonBaseUrl: 'http://localhost:8000',
        javaBaseUrl: 'http://localhost:8080',
        requestTimeout: Duration(seconds: 20),
      ),
    );

    await tester.pumpWidget(SystemRhApp(services: services));

    expect(find.text('Entrar'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
