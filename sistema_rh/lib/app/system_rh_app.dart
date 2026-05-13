import 'package:flutter/material.dart';

import '../screens/tela_login.dart';
import '../widgets/rh_home_page.dart';

class SystemRhApp extends StatelessWidget {
  const SystemRhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Sistema RH',

      home: const LoginPage(),

      routes: {'/home': (context) => const RhHomePage()},
    );
  }
}
