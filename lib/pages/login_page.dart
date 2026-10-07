import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  bool carregando = false;

  Future<void> _entrar() async {
    setState(() {
      carregando = true;
    });

    try {
      await _authService.entrarComGoogle();

    } on FirebaseAuthException catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro no login: ${erro.message ?? erro.code}',
            ),
          ),
        );
      }
    } catch (erro) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao entrar: $erro'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_fix_high,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                'ESCOLA JUJUTSU',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Acesso restrito para feiticeiros',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: carregando ? null : _entrar,
                  icon: carregando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    carregando ? 'Entrando...' : '[ ENTRAR COM GOOGLE ]',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
