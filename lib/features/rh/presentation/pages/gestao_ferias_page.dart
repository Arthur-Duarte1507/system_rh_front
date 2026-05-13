import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

class GestaoFeriasPage extends StatelessWidget {
  const GestaoFeriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RhModuleHeader(
          icon: Icons.beach_access_rounded,
          title: 'Gestao de Ferias',
          subtitle:
              'Planejamento, solicitacoes e historico de periodos de ferias.',
        ),
        const SizedBox(height: 16),
        const RhPageAssignmentBanner(
          fileHint:
              'lib/features/rh/presentation/pages/gestao_ferias_page.dart',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isStacked = constraints.maxWidth < 1020;
            if (isStacked) {
              return const Column(
                children: [
                  RhSectionCard(
                    title: 'Resumo e solicitacao',
                    description:
                        'Area de saldo de dias, solicitacao e status de aprovacao.',
                    items: [
                      'Saldo de ferias disponivel',
                      'Formulario de solicitacao',
                      'Status da solicitacao',
                    ],
                    placeholder:
                        'TODO: resumo de dias + formulario de envio da solicitacao.',
                  ),
                  SizedBox(height: 14),
                  RhSectionCard(
                    title: 'Historico e calendario',
                    description:
                        'Consulta de periodos ja utilizados e previsao dos proximos.',
                    items: [
                      'Historico de ferias',
                      'Calendario de periodos',
                      'Observacoes e bloqueios de data',
                    ],
                    placeholder:
                        'TODO: timeline/lista com filtros por ano e periodo.',
                  ),
                ],
              );
            }

            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RhSectionCard(
                    title: 'Resumo e solicitacao',
                    description:
                        'Area de saldo de dias, solicitacao e status de aprovacao.',
                    items: [
                      'Saldo de ferias disponivel',
                      'Formulario de solicitacao',
                      'Status da solicitacao',
                    ],
                    placeholder:
                        'TODO: resumo de dias + formulario de envio da solicitacao.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: RhSectionCard(
                    title: 'Historico e calendario',
                    description:
                        'Consulta de periodos ja utilizados e previsao dos proximos.',
                    items: [
                      'Historico de ferias',
                      'Calendario de periodos',
                      'Observacoes e bloqueios de data',
                    ],
                    placeholder:
                        'TODO: timeline/lista com filtros por ano e periodo.',
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
