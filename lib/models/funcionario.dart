class Funcionario {
  final int id;
  final String nome;
  final String cargo;
  final String email;
  final String status;
  final String senha; // Adicionado campo de senha
  final String? tempoCasa; // Adicionado campo tempo_casa (aceita nulo)
  final String? aniversario; // Adicionado campo aniversario (aceita nulo)

  Funcionario({
    required this.id,
    required this.nome,
    required this.cargo,
    required this.email,
    required this.status,
    this.senha = '',
    this.tempoCasa,
    this.aniversario,
  });

  /// =========================
  /// JSON -> OBJETO (CORRIGIDO PARA SUCESSO)
  /// =========================
  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      // Usa a sua função utilitária que evita crash de int
      id: _parseInt(json['id']),

      // Força a conversão para String e limpa espaços em branco vazios
      nome: json['nome']?.toString().trim() ?? 'Sem Nome',
      cargo: json['cargo']?.toString().trim() ?? 'Não informado',
      email: json['email']?.toString().trim() ?? '',

      // Mapeia tanto 'status' quanto 'estado_trabalho' que está no seu banco
      status:
          (json['status'] ?? json['estado_trabalho'])?.toString().trim() ??
          'nao_comecou',

      senha: json['senha']?.toString().trim() ?? '',

      // Mapeia os novos campos vindos do banco de dados (Python API)
      tempoCasa: json['tempo_casa']?.toString().trim(),
      aniversario: json['aniversario']?.toString().trim(),
    );
  }

  /// =========================
  /// OBJETO -> JSON (POST/PUT)
  /// =========================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cargo': cargo,
      'email': email,
      'status': status,
      'senha': senha,
      'tempo_casa': tempoCasa, // Envia como tempo_casa para o Python
      'aniversario': aniversario, // Envia como aniversario para o Python
    };
  }

  /// =========================
  /// COPY WITH (IMPORTANTE p/ UPDATE)
  /// =========================
  Funcionario copyWith({
    int? id,
    String? nome,
    String? cargo,
    String? email,
    String? status,
    String? senha,
    String? tempoCasa,
    String? aniversario,
  }) {
    return Funcionario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cargo: cargo ?? this.cargo,
      email: email ?? this.email,
      status: status ?? this.status,
      senha: senha ?? this.senha,
      tempoCasa: tempoCasa ?? this.tempoCasa,
      aniversario: aniversario ?? this.aniversario,
    );
  }

  /// =========================
  /// UTIL: evita crash de int
  /// =========================
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  /// =========================
  /// DEBUG
  /// =========================
  @override
  String toString() {
    return 'Funcionario(id: $id, nome: $nome, cargo: $cargo, email: $email, status: $status, senha: $senha, tempoCasa: $tempoCasa, aniversario: $aniversario)';
  }
}
