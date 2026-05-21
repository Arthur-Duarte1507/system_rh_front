/*
============================
A FAZER:
- Mostrar a data das mensagens no mural
- Mostrar em ordem de crescente de data (mais recente no topo)
- Tempo limite para as mensagens
  1- Urgente: É apagada após ser resolvido (somente o RH pode apagar)
  2- Comunicados: Apagada após 30 dias ou data limite definida por quem postou
- Pensar se o campo de mensagens será apagado do mural ou não.
============================
 */

import 'package:flutter/material.dart';
import 'package:sistema_rh/core/di/app_services.dart';
import 'package:sistema_rh/core/utils/formatters.dart';
import 'dart:math';
import '../widgets/module_base_widgets.dart';
import 'package:sistema_rh/services/local_storage_service.dart';

class DashboardColaboradorPage extends StatelessWidget {
  const DashboardColaboradorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Título da página (com ícone, título e subtítulo)
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

        //Chamamos o nosso novo Card genérico configurado para o dashboard
        const _PerfilConsolidadoCard(),
      ],
    );
  }
}

///Função utilitária para gerar a cor de fundo clara
Color gerarCorClaraAleatoria() {
  final random = Random();

  return HSLColor.fromAHSL(
    1.0, //Transparência
    random.nextDouble() * 360, //Cor aleatória (0 a 360)
    0.5 + random.nextDouble() * 0.2, //Saturação (evitar cor cinza ou muito berrante)
    0.7 + random.nextDouble() * 0.15, //Luminosidade (clara)
  ).toColor();
}
//============================
//COMPOSIÇÃO: Card de perfil
//============================
class _PerfilConsolidadoCard extends StatelessWidget {
  const _PerfilConsolidadoCard();

  //Pega os dados do colaborador da API
  Future<Map<String, dynamic>> obterDados() async {
    final dado = await LocalStorageService().obterFuncionarioId();
    final response = await AppServices.fromEnvironment().pythonApi.get('/api/dashboard/$dado');
    return response ?? {};
  }
  
  @override
  Widget build(BuildContext context) {
    Color corFundo = gerarCorClaraAleatoria();

    return FutureBuilder<Map<String, dynamic>>(
      future: obterDados(),
      builder: (context, snapshot) {
        //Se os dados ainda estão sendo carregados, mostra um ícone de loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        //Caso de erro
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar perfil."));
        }

        final Map<String, dynamic>? dados = snapshot.data;
        final String nomeColaborador = dados!['funcionario']['nome'] ?? "Colaborador";
        final String cargoColaborador = dados['funcionario']['cargo'] ?? "Cargo";
        final String dataAniversario = dados['funcionario']['aniversario'];
        final String tempoCasa = dados['funcionario']['tempo_casa'];
        final String estado = dados['funcionario']['estado_trabalho'];
        final String bancoHoras = dados['banco_horas']['saldo'];

        return RhConsolidadoCard(
          titulo: nomeColaborador,
          subtitulo: cargoColaborador,
          corFundoAvatar: corFundo,
          avatar: nomeColaborador,
          conteudoEsquerda: _Informacoes(
            saldoHoras: bancoHoras,
            dataAniversario: dataAniversario,
            tempoCasa: tempoCasa,
            estado: estado,
          ),
          conteudoDireita: const _MuralAvisos(),
        );
      },
    );
  }
}

//============================================================================
//WIDGET INTERNO: Informações do Trabalhador
//============================================================================
class _Informacoes extends StatelessWidget {
  final String saldoHoras;
  final String dataAniversario;
  final String tempoCasa;
  final String estado;
  
  const _Informacoes({
    required this.saldoHoras,
    required this.dataAniversario,
    required this.tempoCasa,
    required this.estado
  });

  @override
  Widget build(BuildContext context) {
    bool isSaldoPositivo = !saldoHoras.startsWith("-");
    bool isSaldoNeutro = saldoHoras == "0h" || saldoHoras == "";

    Color corBancoHoras = const Color(0xFF0F172A);
    if (!isSaldoNeutro) {
      corBancoHoras = isSaldoPositivo ? const Color(0xFF059669) : Colors.red;
    }

    String textoAniversario = formatarAniversario(formatarData(dataAniversario));

    return Column(
      children: [
        _buildInfoRow(
          'Banco de Horas',
          saldoHoras,
          valueColor: corBancoHoras,
          isBold: true,
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Estado', estado, isBold: true),
        const SizedBox(height: 16),
        _buildInfoRow('Aniversário', textoAniversario),
        const SizedBox(height: 16),
        _buildInfoRow('Tempo de casa', tempoCasa == "" ? "0" : tempoCasa),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Text(
            "$label:",
            style: const TextStyle(fontSize: 16, color: Color(0xFF475569)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor ?? const Color(0xFF0F172A),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

//============================================================================
//WIDGET INTERNO: Mural de Avisos
//============================================================================
class _MuralAvisos extends StatelessWidget {
  const _MuralAvisos();

  @override
  Widget build(BuildContext context) {
    const List<String> avisosUrgentes = [
      'Falta de energia amanhã',
      'Atualização do sistema de ponto',
    ];
    const List<String> avisosComunicados = [
      'Festa de fim de ano',
      'Novos benefícios de saúde',
    ];
    const List<String> avisosMensagens = [
      'RH: Assinar documento pendente',
      'TI: Atualizar senha',
      'RH: Passar no RH',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(129, 226, 232, 240),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'MURAL DE AVISOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 16),
          _MuralExpansivel(titulo: 'Urgente', itens: avisosUrgentes),
          SizedBox(height: 8),
          _MuralExpansivel(titulo: 'Comunicados', itens: avisosComunicados),
          SizedBox(height: 8),
          _MuralExpansivel(titulo: 'Mensagens', itens: avisosMensagens),
        ],
      ),
    );
  }
}

//============================================================================
//WIDGET INTERNO: Botão expansível individual do Mural
//============================================================================
class _MuralExpansivel extends StatelessWidget {
  final String titulo;
  final List<String> itens;

  const _MuralExpansivel({required this.titulo, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9E1EB)),
      ),
      child: ExpansionTile(
        title: Text(
          "$titulo (${itens.length})",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        shape: const Border(),
        children: itens
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '• $item',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}