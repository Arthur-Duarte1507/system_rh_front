import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

class GestaoFeriasPage extends StatefulWidget {
  const GestaoFeriasPage({super.key});

  @override
  State<GestaoFeriasPage> createState() => _GestaoFeriasPageState();
}

class _GestaoFeriasPageState extends State<GestaoFeriasPage> {
  final TextEditingController inicioController = TextEditingController();
  final TextEditingController fimController = TextEditingController();

  int saldoDias = 20;

  final List<Map<String, String>> historicoFerias = [
    {'periodo': '10/01/2025 - 20/01/2025', 'status': 'Aprovado'},
    {'periodo': '05/07/2024 - 15/07/2024', 'status': 'Aprovado'},
  ];

  DateTime? _parseData(String input) {
    try {
      final partes = input.split('/');

      if (partes.length != 3) return null;

      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final data = DateTime(ano, mes, dia);

      // valida se a data realmente existe (ex: 31/02)
      if (data.day != dia || data.month != mes || data.year != ano) {
        return null;
      }

      return data;
    } catch (_) {
      return null;
    }
  }

  int _calcularDias(DateTime inicio, DateTime fim) {
    return fim.difference(inicio).inDays + 1;
  }

  void solicitarFerias() {
    final inicioTexto = inicioController.text.trim();
    final fimTexto = fimController.text.trim();

    final inicio = _parseData(inicioTexto);
    final fim = _parseData(fimTexto);

    // 1. valida existência e formato
    if (inicio == null || fim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data invalida ou inexistente (use dd/MM/yyyy)'),
        ),
      );
      return;
    }

    // 2. valida ordem das datas
    if (inicio.isAfter(fim)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data inicio nao pode ser maior que a data fim'),
        ),
      );
      return;
    }

    final diasSolicitados = _calcularDias(inicio, fim);

    // 3. valida saldo
    if (diasSolicitados > saldoDias) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo insuficiente de ferias')),
      );
      return;
    }

    setState(() {
      saldoDias -= diasSolicitados;

      historicoFerias.insert(0, {
        'periodo': '$inicioTexto - $fimTexto',
        'status': 'Em analise',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Solicitacao enviada ($diasSolicitados dias)')),
    );

    inicioController.clear();
    fimController.clear();
  }

  @override
  void dispose() {
    inicioController.dispose();
    fimController.dispose();
    super.dispose();
  }

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
              return Column(
                children: [
                  _buildResumoSolicitacao(),
                  const SizedBox(height: 14),
                  _buildHistoricoCalendario(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildResumoSolicitacao()),
                const SizedBox(width: 14),
                Expanded(child: _buildHistoricoCalendario()),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildResumoSolicitacao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E1EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo e solicitacao',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Area de saldo de dias, solicitacao e status de aprovacao.',
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.beach_access),
                const SizedBox(width: 10),
                Text(
                  '$saldoDias dias disponiveis',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: inicioController,
            decoration: const InputDecoration(
              labelText: 'Data de inicio (dd/MM/yyyy)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: fimController,
            decoration: const InputDecoration(
              labelText: 'Data de termino (dd/MM/yyyy)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: solicitarFerias,
              icon: const Icon(Icons.send),
              label: const Text('Solicitar Ferias'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricoCalendario() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E1EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historico e calendario',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Consulta de periodos ja utilizados e previsao dos proximos.',
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Historico de Ferias',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ...historicoFerias.map(
            (ferias) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ferias['periodo']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(ferias['status']!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bloqueio de solicitacoes entre 20/12 e 05/01 devido ao fechamento anual.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
