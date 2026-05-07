import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

class DashboardColaboradorPage extends StatelessWidget {
  const DashboardColaboradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RhModuleHeader(
          icon: Icons.space_dashboard_outlined,
          title: 'Dashboard do Colaborador',
          subtitle: 'Perfil do colaborador e mural de comunicados.',
        ),
        const SizedBox(height: 16),
        const RhPageAssignmentBanner(
          fileHint:
              'lib/features/rh/presentation/pages/dashboard_colaborador_page.dart',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isStacked = constraints.maxWidth < 1020;
            if (isStacked) {
              return const Column(
                children: [
                  RhSectionCard(
                    title: 'Informacoes do trabalhador',
                    description:
                        'Bloco principal de perfil para exibir dados da pessoa colaboradora.',
                    items: [
                      'Cargo',
                      'Tempo de casa',
                      'Aniversario',
                      'Prazos de entrega',
                      'Banco de horas simples',
                    ],
                    placeholder:
                        'TODO: componente de perfil com cards ou grid de informacoes.',
                  ),
                  SizedBox(height: 14),
                  RhSectionCard(
                    title: 'Mural de comunicados',
                    description:
                        'Area para noticias internas, avisos e recados de RH.',
                    items: [
                      'Comunicados gerais',
                      'Avisos urgentes',
                      'Mensagens por periodo',
                    ],
                    placeholder:
                        'TODO: lista de comunicados, filtros e item destacado.',
                  ),
                ],
              );
            }

            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RhSectionCard(
                    title: 'Informacoes do trabalhador',
                    description:
                        'Bloco principal de perfil para exibir dados da pessoa colaboradora.',
                    items: [
                      'Cargo',
                      'Tempo de casa',
                      'Aniversario',
                      'Prazos de entrega',
                      'Banco de horas simples',
                    ],
                    placeholder:
                        'TODO: componente de perfil com cards ou grid de informacoes.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: RhSectionCard(
                    title: 'Mural de comunicados',
                    description:
                        'Area para noticias internas, avisos e recados de RH.',
                    items: [
                      'Comunicados gerais',
                      'Avisos urgentes',
                      'Mensagens por periodo',
                    ],
                    placeholder:
                        'TODO: lista de comunicados, filtros e item destacado.',
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
