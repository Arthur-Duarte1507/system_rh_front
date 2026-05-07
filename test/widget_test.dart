import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:system_rh_front/app/system_rh_app.dart';

void main() {
  testWidgets('renderiza a base do sistema de RH com os modulos principais', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SystemRhApp());

    expect(find.text('Sistema de RH'), findsOneWidget);
    expect(find.text('Dashboard do Colaborador'), findsAtLeastNWidgets(2));
    expect(find.text('Gestao de Ponto e Ajustes'), findsOneWidget);
    expect(find.text('Painel Administrativo'), findsOneWidget);
    expect(find.text('Gestao de Ferias'), findsOneWidget);
  });
}
