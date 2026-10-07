import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final MissaoService _service = MissaoService();

  List<Missao> missoes = [];

  bool carregando = true;

  StreamSubscription<List<Missao>>? _assinatura;

  MissaoProvider() {
    FirebaseAuth.instance.authStateChanges().listen((usuario) {
      _assinatura?.cancel();
      _assinatura = null;

      missoes = [];
      carregando = true;

      notifyListeners();

      if (usuario == null) {
        return;
      }

      carregarMissoes();
    });
  }

  void carregarMissoes() {
    _assinatura = _service.listarMissoes().listen((lista) {
      missoes = lista;

      carregando = false;

      notifyListeners();
    });
  }

  Future<void> adicionar(String titulo, int grau) async {
    if (titulo.trim().isEmpty) {
      return;
    }

    await _service.adicionarMissao(
      titulo.trim(),
      grau,
    );
  }

  Future<void> alterarStatus(Missao missao) async {
    await _service.alterarStatus(missao);
  }

  Future<void> excluir(String id) async {
    await _service.excluirMissao(id);
  }

  @override
  void dispose() {
    _assinatura?.cancel();
    super.dispose();
  }
}
