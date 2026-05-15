import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/module_base_widgets.dart';

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

        //Chamamos o nosso novo Card unificado aqui
        const _PerfilConsolidadoCard(),
      ],
    );
  }
}

Color gerarCorClaraAleatoria() {
  final random = Random();

  //Criamos uma cor baseada em HSL:
  //Hue (Matiz): 0 a 360 (todas as cores do arco-íris)
  //Saturation: 0.4 a 0.8 (para não ficar nem cinza, nem berrante)
  //Lightness: 0.6 a 0.85 (GARANTE que a cor seja clara)
  return HSLColor.fromAHSL(
    1.0,
    random.nextDouble() * 360,
    0.5 + random.nextDouble() * 0.2,
    0.7 + random.nextDouble() * 0.15,
  ).toColor();
}

//============================================================================
//NOVO WIDGET: O Retângulo Principal que contém tudo
//============================================================================
class _PerfilConsolidadoCard extends StatelessWidget {
  const _PerfilConsolidadoCard();

  @override
  Widget build(BuildContext context) {
    const String nomeColaborador =
        "Maria Silva"; //TODO: Substituir por variável da API
    const String cargoColaborador =
        "Engenheira de Software Sênior"; //TODO: Substituir por variável da API
    Color corFundo = gerarCorClaraAleatoria();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          //------------------------------------------------------------------
          //PARTE SUPERIOR: FOTO, NOME E CARGO (Acima da linha divisória)
          //------------------------------------------------------------------
          Row(
            children: [
              //Retângulo da foto do colaborador
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF000000)),
                ),
                child: Center(
                  child: Text(
                    nomeColaborador.split(' ').map((n) => n[0]).take(2).join(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              //Textos: Nome e Cargo
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomeColaborador,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      cargoColaborador,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF059669), //Verde padrão do seu sistema
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          //------------------------------------------------------------------
          //LINHA DIVISÓRIA
          //------------------------------------------------------------------
          const Divider(color: Color(0xFFD9E1EB), thickness: 1),
          const SizedBox(height: 20),

          //------------------------------------------------------------------
          //PARTE INFERIOR: DADOS DA ESQUERDA E MURAL DA DIREITA
          //------------------------------------------------------------------
          //Usamos LayoutBuilder igual ao Qt dinâmico: se a tela for pequena,
          //empilhamos as informações (Column). Se for grande, ficam lado a lado (Row).
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 800;

              if (isCompact) {
                return const Column(
                  children: [
                    _Informacoes(),
                    SizedBox(height: 24),
                    _MuralAvisos(),
                  ],
                );
              }

              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: _Informacoes()),
                  SizedBox(width: 40), //Espaço entre as duas colunas
                  Expanded(flex: 1, child: _MuralAvisos()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//============================================================================
//WIDGET INTERNO: Lado Esquerdo (Informações do Trabalhador)
//============================================================================
class _Informacoes extends StatelessWidget {
  const _Informacoes();

  @override
  Widget build(BuildContext context) {
    //VARIÁVEIS DE LÓGICA (Simulando os dados que virão da API)
    String saldoHoras = "+2h 30m";
    //Lógica simples: se o texto começar com "-", é negativo (vermelho).
    bool isSaldoPositivo = !saldoHoras.startsWith("-");
    bool isSaldoNeutro = saldoHoras == "0h" || saldoHoras == "";

    //Define a cor baseada no saldo
    Color corBancoHoras = const Color(0xFF0F172A); //Cor normal
    if (!isSaldoNeutro) {
      corBancoHoras = isSaldoPositivo ? const Color(0xFF059669) : Colors.red;
    }

    //Verifica se o aniversário é hoje
    //TODO: Substituir a data fixa por uma variável que venha da API
    DateTime hoje = DateTime.now();
    DateTime dataAniversario = DateTime(1990, 5, 13);
    bool isAniversarioHoje =
        (hoje.day == dataAniversario.day &&
        hoje.month == dataAniversario.month);

    //Muda o texto do aniversário se for o dia do aniversário
    String textoAniversario = isAniversarioHoje
        ? "🎉${dataAniversario.day}/${dataAniversario.month}/${hoje.year}🎉"
        : "${dataAniversario.day}/${dataAniversario.month}/${hoje.year}";

    return Column(
      children: [
        _buildInfoRow(
          'Banco de Horas',
          saldoHoras,
          valueColor: corBancoHoras,
          isBold: true,
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Estado', 'TRABALHANDO', isBold: true),
        const SizedBox(height: 16),
        _buildInfoRow('Aniversário', textoAniversario),
        const SizedBox(height: 16),
        _buildInfoRow('Tempo de casa', '3 anos e 2 meses'),
      ],
    );
  }

  //Função ajudante para desenhar cada linha (Texto Esquerdo ----- Texto Direito)
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
//WIDGET INTERNO: Lado Direito (Mural de Avisos)
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
        color: const Color(
          0xFFE2E8F0,
        ).withOpacity(0.5), //Fundo acinzentado/azulado bem claro
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

          //ExpansionTile é o widget nativo do Flutter para listas que expandem ao clicar
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
        shape:
            const Border(), //Remove as linhas estranhas que o Flutter coloca por padrão
        //Faz um loop na lista de itens (textos) e transforma em widgets de Padding com Text
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
