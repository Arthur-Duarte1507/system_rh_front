import 'package:flutter/material.dart';

import '../core/di/app_scope.dart';
import '../core/di/app_services.dart';
import '../screens/tela_login.dart';
import '../widgets/rh_home_page.dart';

class SystemRhApp extends StatelessWidget {
  const SystemRhApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: services,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sistema RH',
        home: const LoginPage(),
        routes: {'/home': (context) => const RhHomePage()},
      ),
    );
  }
}
