import 'package:flutter/material.dart';

import '../features/rh/presentation/rh_home_page.dart';

class SystemRhApp extends StatelessWidget {
  const SystemRhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RH Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059669)),
        scaffoldBackgroundColor: const Color(0xFFE9EFF5),
        fontFamily: 'Montserrat',
      ),
      home: const RhHomePage(),
    );
  }
}
