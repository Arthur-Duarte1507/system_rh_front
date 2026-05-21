import 'package:flutter/material.dart';
import 'package:sistema_rh/services/local_storage_service.dart';

import '../core/di/app_scope.dart';
import '../core/network/api_exception.dart';
import '../widgets/rh_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  Future<void> fazerLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe email e senha')));
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      loading = true;
    });

    try {
      final response = await context.services.pythonApi.post(
        '/api/auth/login',
        body: {'email': email, 'senha': senha},
      );
      //Salva o ID do funcionário para uso nas outras telas
      final funcionarioId = response['usuario']['id'].toString();
      await LocalStorageService().salvarFuncionarioId(funcionarioId);
      //print(funcionarioId);
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RhHomePage()),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Falha ao realizar login.')));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          return Row(
            children: [
              // LADO ESQUERDO
              if (!isMobile)
                Expanded(
                  flex: 5,
                  child: Container(
                    color: const Color(0xFF0F172A),

                    padding: const EdgeInsets.all(60),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 82,
                          height: 82,

                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(22),
                          ),

                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Sistema de RH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Gerencie colaboradores, ponto, férias e processos administrativos em um único ambiente.',
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 17,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 40),

                        _buildFeature(
                          Icons.access_time_rounded,
                          'Controle de ponto',
                        ),

                        _buildFeature(
                          Icons.beach_access_rounded,
                          'Gestão de férias',
                        ),

                        _buildFeature(
                          Icons.admin_panel_settings_outlined,
                          'Painel administrativo',
                        ),
                      ],
                    ),
                  ),
                ),

              // LOGIN
              Expanded(
                flex: 4,

                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 430),

                      padding: const EdgeInsets.all(32),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),

                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 24,
                            color: Colors.black12,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entrar',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'Acesse sua conta para continuar',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 34),

                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'Email',

                              prefixIcon: const Icon(Icons.person_outline),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller: senhaController,
                            obscureText: obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              if (!loading) {
                                fazerLogin();
                              }
                            },

                            decoration: InputDecoration(
                              labelText: 'Senha',

                              prefixIcon: const Icon(Icons.lock_outline),

                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 56,

                            child: ElevatedButton(
                              onPressed: loading ? null : fazerLogin,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),

                                foregroundColor: Colors.white,

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              child: loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,

                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 14),

          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
