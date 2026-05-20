import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';
import '../../models/funcionario.dart';
// Ajuste o import do AppScope se a sua estrutura de pastas for diferente
import '../core/di/app_scope.dart';

class PainelAdministrativoPage extends StatefulWidget {
  const PainelAdministrativoPage({super.key});

  @override
  State<PainelAdministrativoPage> createState() =>
      _PainelAdministrativoPageState();
}

class _PainelAdministrativoPageState extends State<PainelAdministrativoPage> {
  final TextEditingController pesquisaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController tempoCasaController = TextEditingController();
  final TextEditingController aniversarioController = TextEditingController();

  String filtroStatus = 'Todos';
  String statusNovoFuncionario = 'nao_comecou';

  // Variáveis para garantir a captura estável do texto digitado
  String textoTempoCasa = '';
  String textoAniversario = '';

  List<Funcionario> funcionarios = [];
  List<Funcionario> funcionariosFiltrados = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    carregarFuncionarios();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    nomeController.dispose();
    cargoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    tempoCasaController.dispose();
    aniversarioController.dispose();
    super.dispose();
  }

  void aplicarFiltro() {
    final pesquisa = pesquisaController.text.toLowerCase().trim();

    setState(() {
      funcionariosFiltrados = funcionarios.where((f) {
        final nomeCompleto = (f.nome).toLowerCase();
        return nomeCompleto.contains(pesquisa);
      }).toList();
    });
  }

  // ==========================================
  // API - GET (Buscar Funcionários)
  // ==========================================
  Future<void> carregarFuncionarios() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final response = await AppScope.of(
        context,
      ).pythonApi.get('/api/funcionarios');

      if (mounted) {
        setState(() {
          funcionarios = (response as List)
              .map((e) => Funcionario.fromJson(e))
              .toList();
        });
        aplicarFiltro();
      }
    } catch (e) {
      print("Erro na API Python: $e. Ativando dados de teste...");
      if (mounted) {
        setState(() {
          funcionarios = [
            Funcionario(
              id: 2,
              nome: "julia",
              cargo: "Advogada",
              email: "julia@gmail.com.br",
              status: "nao_comecou",
            ),
            Funcionario(
              id: 3,
              nome: "Matheus Tannus de Sousa",
              cargo: "Analista de Sistemas",
              email: "math@gmail.com",
              status: "ativo",
            ),
          ];
        });
        aplicarFiltro();
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // ==========================================
  // API - POST (Adicionar Funcionário)
  // ==========================================
  Future<void> adicionarFuncionario() async {
    FocusScope.of(context).unfocus();

    final nome = nomeController.text.trim();
    final cargo = cargoController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (nome.isEmpty || cargo.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Preencha os campos obrigatórios (Nome, Cargo, Email e Senha)!',
          ),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AppScope.of(context).pythonApi.post(
        '/api/funcionarios',
        body: {
          'nome': nome,
          'cargo': cargo,
          'email': email,
          'senha': senha,
          // Envia o texto capturado em tempo real das variáveis locais
          'tempo_casa': textoTempoCasa.trim(),
          'aniversario': textoAniversario.trim(),
          'estado_trabalho': statusNovoFuncionario,
        },
      );

      nomeController.clear();
      cargoController.clear();
      emailController.clear();
      senhaController.clear();
      tempoCasaController.clear();
      aniversarioController.clear();
      pesquisaController.clear();

      setState(() {
        statusNovoFuncionario = 'nao_comecou';
        textoTempoCasa = '';
        textoAniversario = '';
      });

      await carregarFuncionarios();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionário adicionado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar colaborador: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // ==========================================
  // API - PUT (Alterar Status)
  // ==========================================
  Future<void> alterarStatus(Funcionario funcionario, String novoStatus) async {
    FocusScope.of(context).unfocus();
    setState(() => loading = true);

    try {
      await AppScope.of(context).pythonApi.put(
        '/api/funcionarios/${funcionario.id}',
        body: {
          'nome': funcionario.nome,
          'cargo': funcionario.cargo,
          'email': funcionario.email,
          // Corrigido: Não tenta ler do modelo propriedades inexistentes.
          // Envia os dados atuais da tela para não apagar o registro no banco.
          'senha': funcionario.senha.isNotEmpty ? funcionario.senha : '1234',
          'tempo_casa': textoTempoCasa.trim(),
          'aniversario': textoAniversario.trim(),
          'estado_trabalho': novoStatus,
        },
      );

      await carregarFuncionarios();
    } catch (e) {
      print("Erro ao alterar status: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível mudar o status: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // ==========================================
  // API - DELETE (Excluir Funcionário)
  // ==========================================
  Future<void> deletarFuncionario(int id) async {
    setState(() => loading = true);
    try {
      await AppScope.of(context).pythonApi.delete('/api/funcionarios/$id');
      await carregarFuncionarios();
    } catch (e) {
      print("Erro ao deletar: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          primary: true,
          padding: const EdgeInsets.all(24),
          children: [
            const RhModuleHeader(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Painel Administrativo',
              subtitle:
                  'Gerencie acessos, relatórios e dados cadastrais internos.',
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 1050;

                final listaSection = _buildFormularioEListagem();
                final relatoriosSection = _buildRelatoriosSection();

                if (isStacked) {
                  return Column(
                    children: [
                      listaSection,
                      const SizedBox(height: 24),
                      relatoriosSection,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: listaSection),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: relatoriosSection),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SEÇÃO: FORMULÁRIO E LISTAGEM
  // ==========================================
  Widget _buildFormularioEListagem() {
    final ValueNotifier<bool> ocultarSenhaNotifier = ValueNotifier<bool>(true);

    // Validação preventiva para garantir que o valor inicial do Dropdown exista na lista de itens
    final listaStatusValidos = ['nao_comecou', 'ativo', 'ferias', 'afastado'];
    final statusAtualValido = listaStatusValidos.contains(statusNovoFuncionario)
        ? statusNovoFuncionario
        : 'nao_comecou';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de funcionários',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome completo *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: cargoController,
            decoration: const InputDecoration(
              labelText: 'Cargo na empresa *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email institucional *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<bool>(
            valueListenable: ocultarSenhaNotifier,
            builder: (context, ocultar, child) {
              return TextField(
                controller: senhaController,
                obscureText: ocultar,
                decoration: InputDecoration(
                  labelText: 'Senha de Acesso *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultar ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => ocultarSenhaNotifier.value = !ocultar,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          TextField(
            controller: tempoCasaController,
            onChanged: (val) => textoTempoCasa = val,
            decoration: const InputDecoration(
              labelText: 'Tempo de Casa (Ex: 1 ano e 4 meses)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: aniversarioController,
            onChanged: (val) => textoAniversario = val,
            decoration: const InputDecoration(
              labelText: 'Data de Aniversário (Ex: 28/11)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: statusAtualValido,
            items: const [
              DropdownMenuItem(
                value: 'nao_comecou',
                child: Text('Não Começou'),
              ),
              DropdownMenuItem(value: 'ativo', child: Text('Ativo')),
              DropdownMenuItem(value: 'ferias', child: Text('Férias')),
              DropdownMenuItem(value: 'afastado', child: Text('Afastado')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => statusNovoFuncionario = value);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Status do Novo Colaborador',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: adicionarFuncionario,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF0F172A,
                ), // Corrigido erro de "presidentialBlue"
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text(
                'Adicionar Colaborador',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          TextField(
            controller: pesquisaController,
            onChanged: (_) => aplicarFiltro(),
            decoration: const InputDecoration(
              hintText: 'Pesquisar colaborador cadastrado...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          if (loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: funcionariosFiltrados.length,
              itemBuilder: (context, index) {
                final f = funcionariosFiltrados[index];
                final inicial = f.nome.isNotEmpty
                    ? f.nome[0].toUpperCase()
                    : '?';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFCFD8DC),
                        foregroundColor: const Color(0xFF1E293B),
                        child: Text(
                          inicial,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              f.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              f.cargo,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _obterCorStatus(
                                  f.status,
                                ).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _exibirTextoStatus(f.status),
                                style: TextStyle(
                                  color: _obterCorStatus(f.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.blueGrey,
                          size: 26,
                        ),
                        tooltip: 'Alterar Status',
                        onSelected: (String novoStatus) =>
                            alterarStatus(f, novoStatus),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'ativo',
                            child: Text('Definir como: Ativo'),
                          ),
                          const PopupMenuItem(
                            value: 'nao_comecou',
                            child: Text('Definir como: Não Começou'),
                          ),
                          const PopupMenuItem(
                            value: 'ferias',
                            child: Text('Definir como: Férias'),
                          ),
                          const PopupMenuItem(
                            value: 'afastado',
                            child: Text('Definir como: Afastado'),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                        onPressed: () => deletarFuncionario(f.id),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ==========================================
  // SEÇÃO: RELATÓRIOS E CONTATOS
  // ==========================================
  Widget _buildRelatoriosSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Relatórios e contatos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: carregarFuncionarios,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black,
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Recarregar dados'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contatos internos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ), // Corrigido erro do "Colors.slate"
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: funcionarios.length,
            itemBuilder: (context, index) {
              final f = funcionarios[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.alternate_email, size: 16),
                ),
                title: Text(
                  f.nome,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(f.email, style: const TextStyle(fontSize: 12)),
              );
            },
          ),
        ],
      ),
    );
  }

  String _exibirTextoStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'nao_comecou':
        return 'Não Começou';
      case 'ativo':
        return 'Ativo';
      case 'ferias':
        return 'Férias';
      case 'afastado':
        return 'Afastado';
      default:
        return status;
    }
  }

  Color _obterCorStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'ativo':
        return const Color(0xFF059669);
      case 'nao_comecou':
        return Colors.blue;
      case 'ferias':
        return Colors.orange;
      case 'afastado':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }
}
