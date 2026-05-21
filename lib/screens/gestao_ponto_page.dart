import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

class GestaoPontoPage extends StatelessWidget {
  const GestaoPontoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RhModuleHeader(
          icon: Icons.access_time_rounded,
          title: 'Gestão de Ponto e Ajustes',
          subtitle:
              'Controle diário de horas, status de trabalho e justificativas.',
        ),
        const SizedBox(height: 16),
        const RhPageAssignmentBanner(
          fileHint: 'lib/features/rh/presentation/pages/gestao_ponto_page.dart',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isStacked = constraints.maxWidth < 1020;
            if (isStacked) {
              return const Column(
                children: [
                  RhSectionCard(
                    title: 'Ponto diário',
                    description:
                        'Área principal para acompanhar a jornada do dia em tempo real.',
                    items: [
                      'Mostrar tempo trabalhado no dia',
                      'Botao de bater o ponto',
                      'Estado atual: nao comecou, trabalhando, saida, falta, ferias',
                    ],
                    placeholder:
                        'TODO: painel com cronometro e acoes de entrada/saida.',
                  ),
                  SizedBox(height: 14),
                  RhSectionCard(
                    title: 'Ajustes e banco de horas',
                    description:
                        'Fluxo para justificativas, correcoes e historico detalhado de horas.',
                    items: [
                      'Formulario para justificativa de falta ou correcao',
                      'Banco de horas detalhado',
                      'Historico de solicitacoes',
                    ],
                    placeholder:
                        'TODO: formulario + tabela de banco de horas por periodo.',
                  ),
                ],
              );
            }

            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RhSectionCard(
                    title: 'Ponto diario',
                    description:
                        'Area principal para acompanhar a jornada do dia em tempo real.',
                    items: [
                      'Mostrar tempo trabalhado no dia',
                      'Botao de bater o ponto',
                      'Estado atual: nao comecou, trabalhando, saida, falta, ferias',
                    ],
                    placeholder:
                        'TODO: painel com cronometro e acoes de entrada/saida.',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: RhSectionCard(
                    title: 'Ajustes e banco de horas',
                    description:
                        'Fluxo para justificativas, correcoes e historico detalhado de horas.',
                    items: [
                      'Formulario para justificativa de falta ou correcao',
                      'Banco de horas detalhado',
                      'Historico de solicitacoes',
                    ],
                    placeholder:
                        'TODO: formulario + tabela de banco de horas por periodo.',
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
