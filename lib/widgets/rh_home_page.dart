import 'package:flutter/material.dart';

import '../screens/dashboard_colaborador_page.dart';
import '../screens/gestao_ferias_page.dart';
import '../screens/gestao_ponto_page.dart';
import '../screens/painel_administrativo_page.dart';
import '../screens/tela_login.dart';

enum RhModule {
  dashboardColaborador,
  gestaoPonto,
  painelAdministrativo,
  gestaoFerias,
}

class RhHomePage extends StatefulWidget {
  const RhHomePage({super.key});

  @override
  State<RhHomePage> createState() => _RhHomePageState();
}

class _RhHomePageState extends State<RhHomePage> {
  RhModule _selectedModule = RhModule.dashboardColaborador;

  static const List<_ModuleDefinition> _modules = [
    _ModuleDefinition(
      module: RhModule.dashboardColaborador,
      title: 'Dashboard do Colaborador',
      subtitle: 'Perfil + comunicados',
      icon: Icons.space_dashboard_outlined,
    ),
    _ModuleDefinition(
      module: RhModule.gestaoPonto,
      title: 'Gestao de Ponto e Ajustes',
      subtitle: 'Jornada diaria e justificativas',
      icon: Icons.access_time_rounded,
    ),
    _ModuleDefinition(
      module: RhModule.painelAdministrativo,
      title: 'Painel Administrativo',
      subtitle: 'Relatorios + lista de contatos',
      icon: Icons.admin_panel_settings_outlined,
    ),
    _ModuleDefinition(
      module: RhModule.gestaoFerias,
      title: 'Gestao de Ferias',
      subtitle: 'Solicitacoes e historico',
      icon: Icons.beach_access_rounded,
    ),
  ];

  _ModuleDefinition get _activeModule {
    return _modules.firstWhere((module) => module.module == _selectedModule);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 980;
        if (isCompact) {
          return _buildCompactScaffold(context);
        }
        return _buildDesktopScaffold();
      },
    );
  }

  Widget _buildDesktopScaffold() {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(isDrawer: false),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _buildMainContent(),
                ), // Ocupa o espaço restante perfeitamente
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62,
        elevation: 0,
        backgroundColor: const Color(0xFFF1F4F7),
        foregroundColor: const Color(0xFF0F172A),
        title: Text(
          _activeModule.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(child: _buildSidebarContent(isDrawer: true)),
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildSidebar({required bool isDrawer}) {
    return Container(
      width: isDrawer ? null : 300,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        border: Border(
          right: BorderSide(
            color: const Color(0xFFE2E8F0),
            width: isDrawer ? 0 : 1,
          ),
        ),
      ),
      child: SafeArea(child: _buildSidebarContent(isDrawer: isDrawer)),
    );
  }

  Widget _buildSidebarContent({required bool isDrawer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistema de RH',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Base do frontend',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 6),
          child: Text(
            'Modulos principais',
            style: TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            itemCount: _modules.length,
            itemBuilder: (context, index) {
              final module = _modules[index];
              final isSelected = _selectedModule == module.module;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _onSelectModule(module.module, isDrawer),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? const Color(0xFFE6EDF6)
                          : Colors.transparent,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          module.icon,
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF475569),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.title,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFF1E293B),
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                module.subtitle,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        Padding(
          padding: const EdgeInsets.all(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.withOpacity(0.06),
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Sair',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 62,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F4F7),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(_activeModule.icon, color: const Color(0xFF0F172A), size: 20),
          const SizedBox(width: 10),
          Text(
            _activeModule.title,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // MODIFICADO: Removemos o SingleChildScrollView global perigoso daqui
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: _buildModulePage(),
        ),
      ),
    );
  }

  Widget _buildModulePage() {
    switch (_selectedModule) {
      case RhModule.dashboardColaborador:
        return const DashboardColaboradorPage();
      case RhModule.gestaoPonto:
        return const GestaoPontoPage();
      case RhModule.painelAdministrativo:
        // Agora o Painel pode calcular o seu tamanho e gerenciar o próprio scroll interno se necessário
        return const PainelAdministrativoPage();
      case RhModule.gestaoFerias:
        return const GestaoFeriasPage();
    }
  }

  void _onSelectModule(RhModule module, bool isDrawer) {
    setState(() {
      _selectedModule = module;
    });

    if (isDrawer && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

class _ModuleDefinition {
  const _ModuleDefinition({
    required this.module,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final RhModule module;
  final String title;
  final String subtitle;
  final IconData icon;
}
