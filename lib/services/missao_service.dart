import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/missao.dart';

class MissaoService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final String colecao = 'missoes';

  Stream<List<Missao>> listarMissoes() {
    return _firebase
        .collection(colecao)
        .where(
          'usuarioId',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((documento) {
        return Missao.fromMap(
          documento.id,
          documento.data(),
        );
      }).toList();
    });
  }

  Future<void> adicionarMissao(String titulo, int grau) async {
    await _firebase.collection(colecao).add({
      'titulo': titulo,
      'grau': grau,
      'concluida': false,
      'usuarioId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> alterarStatus(Missao missao) async {
    await _firebase.collection(colecao).doc(missao.id).update({
      'concluida': !missao.concluida,
    });
  }

  Future<void> excluirMissao(String id) async {
    await _firebase.collection(colecao).doc(id).delete();
  }
}
