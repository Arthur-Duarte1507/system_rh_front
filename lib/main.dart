import 'package:flutter/material.dart';

import 'app/system_rh_app.dart';
import 'core/di/app_services.dart';

void main() {
  runApp(const _SystemRhBootstrap());
}

class _SystemRhBootstrap extends StatefulWidget {
  const _SystemRhBootstrap();

  @override
  State<_SystemRhBootstrap> createState() => _SystemRhBootstrapState();
}

class _SystemRhBootstrapState extends State<_SystemRhBootstrap> {
  late final AppServices _services;

  @override
  void initState() {
    super.initState();
    _services = AppServices.fromEnvironment();
  }

  @override
  void dispose() {
    _services.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemRhApp(services: _services);
  }
}
