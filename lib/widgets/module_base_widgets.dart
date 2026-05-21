import 'package:flutter/material.dart';

class RhModuleHeader extends StatelessWidget {
  const RhModuleHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 700;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: isCompact ? 48 : 56,
          width: isCompact ? 48 : 56,
          decoration: BoxDecoration(
            color: const Color(0xFF059669),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: isCompact ? 22 : 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: isCompact ? 28 : 38,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: isCompact ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RhSectionCard extends StatelessWidget {
  const RhSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.items,
    required this.placeholder,
  });

  final String title;
  final String description;
  final List<String> items;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(
                      Icons.circle,
                      size: 7,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD8E2ED)),
            ),
            child: Text(
              placeholder,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RhConsolidadoCard extends StatelessWidget {
  final Widget conteudoEsquerda;
  final Widget? conteudoDireita;
  final String? titulo;
  final String? subtitulo;
  final Color? corFundoAvatar;
  final dynamic avatar;

  //Se titulo, subtitulo e avatar forem nulos, o card renderiza apenas os conteúdos sem seção de perfil no topo.
  const RhConsolidadoCard({
    super.key,
    required this.conteudoEsquerda,
    this.conteudoDireita,
    this.titulo,
    this.subtitulo,
    this.corFundoAvatar,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final bool mostrarCabecalho = titulo != null || subtitulo != null || avatar != null;

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
          //CABEÇALHO
          //------------------------------------------------------------------
          if (mostrarCabecalho) ...[
            Row(
              children: [
                //Avatar
                if (avatar != null)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: corFundoAvatar ?? const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF000000)),
                    ),
                    child: Center(
                      child: _buildAvatarChild(),
                    ),
                  ),
                const SizedBox(width: 16),
                //Textos: Título e Subtítulo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (titulo != null)
                        Text(
                          titulo!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      if (subtitulo != null)
                        Text(
                          subtitulo!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            //Linha Divisória visível se o cabeçalho existir
            const Divider(color: Color(0xFFD9E1EB), thickness: 1),
            const SizedBox(height: 20),
          ],
          //------------------------------------------------------------------
          //WIDGETS DIREITA E ESQUERDA
          //------------------------------------------------------------------
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 800;

              if (conteudoDireita == null) {
                return conteudoEsquerda;
              }
              //Renderiza em coluna se a tela for pequena
              if (isCompact) {
                return Column(
                  children: [
                    conteudoEsquerda,
                    const SizedBox(height: 24),
                    conteudoDireita!,
                  ],
                );
              }
              //Se for normal, renderiza em linha
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: conteudoEsquerda),
                  const SizedBox(width: 40),
                  Expanded(flex: 1, child: conteudoDireita!),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  //Verifica o tipo do avatar fornecido e renderiza o widget apropriado:
    Widget _buildAvatarChild() {
    //Caso o avatar é nulo, uso o título como avatar
    if (avatar == null) {
      return _buildFallbackText(titulo);
    }

    //Se o avatar for um Ícone do Flutter
    if (avatar is IconData) {
      return _buildIconAvatar(avatar as IconData);
    }

    //Se o avatar for um texto ou caminho de imagem
    if (avatar is String) {
      final String strAvatar = avatar as String;

      if (strAvatar.startsWith('http') || strAvatar.startsWith('assets/')) {
        return _buildImageAvatar(strAvatar);
      }
      return _buildTextAvatar(strAvatar);
    }
    //Retorno preventivo
    return _buildFallbackText(titulo);
  }

  //Rederiza avatar com ícone
  Widget _buildIconAvatar(IconData icon) {
    return Icon(
      icon,
      size: 32,
      color: const Color(0xFF0F172A),
    );
  }

  //Renderiza avatar com imagem
  Widget _buildImageAvatar(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: path.startsWith('http')
          ? Image.network(
              path,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => _buildFallbackText(titulo),
            )
          : Image.asset(
              path,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => _buildFallbackText(titulo),
            ),
    );
  }

  //Renderiza avatar com texto
  Widget _buildTextAvatar(String text) {
    String textoExibido = text.trim();
    final RegExp regexAlfabetica = RegExp(r'[a-zA-ZÀ-ÿ]');

    //Se for um texto separa em palavras e pega as iniciais
    if (regexAlfabetica.hasMatch(textoExibido)) {
      final List<String> palavras = textoExibido
          .split(' ')
          .where((p) => p.trim().isNotEmpty)
          .toList();

      if (palavras.isNotEmpty) {
        if (palavras.length == 1) {
          textoExibido = palavras[0][0].toUpperCase();
        } else {
          final String inicialPrimeiroNome = palavras.first[0];
          final String inicialSobrenome = palavras.last[0];
          textoExibido = '$inicialPrimeiroNome$inicialSobrenome'.toUpperCase();
        }
      }
    }

    return Text(
      textoExibido,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0F172A),
      ),
    );
  }

  //Renderiza um avatar com o texto se necessário ou widget vazio
  Widget _buildFallbackText(String? fallbackTitle) {
    if (fallbackTitle == null || fallbackTitle.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return _buildTextAvatar(fallbackTitle);
  }
}

class RhPageAssignmentBanner extends StatelessWidget {
  const RhPageAssignmentBanner({super.key, required this.fileHint});

  final String fileHint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
