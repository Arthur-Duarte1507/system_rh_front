import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

class PainelAdministrativoPage extends StatelessWidget {
  const PainelAdministrativoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RhModuleHeader(
          icon: Icons.admin_panel_settings_outlined,
          title: 'Painel Administrativo',
          subtitle: 'Relatorios, lista de funcionarios e contatos internos.',
        ),
        const SizedBox(height: 16),
        const RhPageAssignmentBanner(
          fileHint:
              'lib/features/rh/presentation/pages/painel_administrativo_page.dart',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isStacked = constraints.maxWidth < 1020;
            if (isStacked) {
              return const Column(
                children: [
                  RhSectionCard(
                    title: 'Lista de funcionarios',
                    description:
                        'Tela administrativa com dados basicos e status de trabalho.',
                    items: ['Nome', 'Cargo', 'Estado de trabalho', 'Email'],
                    placeholder:
                        'TODO: tabela paginada, filtros e acao de abrir detalhes.',
                  ),
                  SizedBox(height: 14),
                  RhSectionCard(
                    title: 'Relatorios e contatos',
                    description:
                        'Area para gerar relatorios de presenca e consultar contatos.',
                    items: [
                      'Gerar relatorios de presenca',
                      'Relatorio de desempenho (opcional)',
                      'Lista de contatos internos',
                    ],
                    placeholder:
                        'TODO: filtros por periodo, exportacao e cards de resumo.',
                  ),
                ],
              );
            }

            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RhSectionCard(
                    title: 'Lista de funcionarios',
                    description:
                        'Tela administrativa com dados basicos e status de trabalho.',
                    items: ['Nome', 'Cargo', 'Estado de trabalho', 'Email'],
                    placeholder:
                        'TODO: tabela paginada, filtros e acao de abrir detalhes.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: RhSectionCard(
                    title: 'Relatorios e contatos',
                    description:
                        'Area para gerar relatorios de presenca e consultar contatos.',
                    items: [
                      'Gerar relatorios de presenca',
                      'Relatorio de desempenho (opcional)',
                      'Lista de contatos internos',
                    ],
                    placeholder:
                        'TODO: filtros por periodo, exportacao e cards de resumo.',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
