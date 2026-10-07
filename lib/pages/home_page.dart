import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/missao_provider.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController grauController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  void dispose() {
    tituloController.dispose();
    grauController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _cadastrarMissao() async {
    final provider = context.read<MissaoProvider>();

    final String titulo = tituloController.text.trim();
    final int? grau = int.tryParse(grauController.text.trim());

    if (titulo.isEmpty) {
      _mostrarMensagem('Digite o título da missão.');
      return;
    }

    if (grau == null) {
      _mostrarMensagem('Digite um grau válido (ex.: 2).');
      return;
    }

    await provider.adicionar(titulo, grau);

    tituloController.clear();
    grauController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Jujutsu'),
        actions: [
          IconButton(
            tooltip: 'Sair da conta',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.sair();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (usuario?.photoURL != null)
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          usuario!.photoURL!,
                        ),
                      )
                    else
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person),
                      ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem-vindo, ${usuario?.displayName ?? 'Usuário'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            usuario?.email ?? 'E-mail não disponível',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da missão',
                hintText: 'Ex.: Investigar maldição na escola',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: grauController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Grau (ex.: 2)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _cadastrarMissao,
                child: const Text('Cadastrar missão'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Consumer<MissaoProvider>(
                builder: (context, provider, child) {
                  if (provider.carregando) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.missoes.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma missão cadastrada.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.missoes.length,
                    itemBuilder: (context, index) {
                      final missao = provider.missoes[index];

                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: missao.concluida,
                            onChanged: (valor) {
                              provider.alterarStatus(missao);
                            },
                          ),

                          title: Text(
                            missao.titulo,
                            style: TextStyle(
                              decoration: missao.concluida
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          subtitle: Text('Grau: ${missao.grau}'),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.excluir(missao.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
