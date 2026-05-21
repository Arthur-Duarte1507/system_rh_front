import 'package:flutter/material.dart';

import '../widgets/module_base_widgets.dart';

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

  String filtroStatus = 'Todos';

  String statusNovoFuncionario = 'Ativo';

  // ===============================
  // TEMPORARIO
  // futuramente integrar com banco/API
  // ===============================

  final List<Map<String, String>> funcionarios = [
    {
      'nome': 'Carlos Silva',
      'cargo': 'Desenvolvedor',
      'status': 'Ativo',
      'email': 'carlos@empresa.com',
    },
    {
      'nome': 'Ana Souza',
      'cargo': 'RH',
      'status': 'Ferias',
      'email': 'ana@empresa.com',
    },
    {
      'nome': 'Marcos Lima',
      'cargo': 'Financeiro',
      'status': 'Ativo',
      'email': 'marcos@empresa.com',
    },
  ];

  List<Map<String, String>> get funcionariosFiltrados {
    return funcionarios.where((funcionario) {
      final nome = funcionario['nome']!.toLowerCase();

      final pesquisa = pesquisaController.text.toLowerCase();

      final status = funcionario['status'];

      final pesquisaOk = nome.contains(pesquisa);

      final statusOk = filtroStatus == 'Todos' || status == filtroStatus;

      return pesquisaOk && statusOk;
    }).toList();
  }

  void adicionarFuncionario() {
    if (nomeController.text.isEmpty ||
        cargoController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));

      return;
    }

    setState(() {
      funcionarios.add({
        'nome': nomeController.text,
        'cargo': cargoController.text,
        'status': statusNovoFuncionario,
        'email': emailController.text,
      });
    });

    nomeController.clear();
    cargoController.clear();
    emailController.clear();

    statusNovoFuncionario = 'Ativo';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Funcionario adicionado')));
  }

  void alterarStatus(int index, String novoStatus) {
    setState(() {
      funcionarios[index]['status'] = novoStatus;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Status alterado para $novoStatus')));
  }

  void gerarRelatorio() {
    // TEMPORARIO
    // futuramente gerar PDF/excel

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relatorio gerado com sucesso')),
    );
  }

  void abrirDetalhes(Map<String, String> funcionario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(funcionario['nome']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cargo: ${funcionario['cargo']}'),

            const SizedBox(height: 8),

            Text('Status: ${funcionario['status']}'),

            const SizedBox(height: 8),

            Text('Email: ${funcionario['email']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    nomeController.dispose();
    cargoController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RhModuleHeader(
          icon: Icons.admin_panel_settings_outlined,
          title: 'Painel Administrativo',
          subtitle: 'Relatorios, lista de funcionários e contatos internos.',
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
              return Column(
                children: [
                  _buildFuncionarios(),

                  const SizedBox(height: 14),

                  _buildRelatorios(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildFuncionarios()),

                const SizedBox(width: 14),

                Expanded(child: _buildRelatorios()),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFuncionarios() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E1EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de funcionarios',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: cargoController,
            decoration: const InputDecoration(
              labelText: 'Cargo',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: statusNovoFuncionario,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
              DropdownMenuItem(value: 'Ferias', child: Text('Ferias')),
              DropdownMenuItem(value: 'Afastado', child: Text('Afastado')),
            ],
            onChanged: (value) {
              setState(() {
                statusNovoFuncionario = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: adicionarFuncionario,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Colaborador'),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: pesquisaController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Pesquisar funcionario',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),

          const SizedBox(height: 20),

          ...funcionariosFiltrados.map((funcionario) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Text(funcionario['nome']![0])),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          funcionario['nome']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(funcionario['cargo']!),

                        DropdownButton<String>(
                          value: funcionario['status'],
                          items: const [
                            DropdownMenuItem(
                              value: 'Ativo',
                              child: Text('Ativo'),
                            ),
                            DropdownMenuItem(
                              value: 'Ferias',
                              child: Text('Ferias'),
                            ),
                            DropdownMenuItem(
                              value: 'Afastado',
                              child: Text('Afastado'),
                            ),
                          ],
                          onChanged: (value) {
                            final indexReal = funcionarios.indexOf(funcionario);

                            alterarStatus(indexReal, value!);
                          },
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => abrirDetalhes(funcionario),
                    icon: const Icon(Icons.visibility),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRelatorios() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E1EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Relatorios e contatos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: gerarRelatorio,
              icon: const Icon(Icons.download),
              label: const Text('Gerar Relatorio'),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Lista de contatos internos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ...funcionarios.map(
            (funcionario) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(funcionario['nome']!),
              subtitle: Text(funcionario['email']!),
            ),
          ),
        ],
      ),
    );
  }
}
