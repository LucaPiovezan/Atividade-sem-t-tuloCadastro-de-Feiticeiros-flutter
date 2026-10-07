class Missao {
  String id;
  String titulo;
  int grau;
  bool concluida;
  String usuarioId;

  Missao({
    required this.id,
    required this.titulo,
    required this.grau,
    required this.concluida,
    required this.usuarioId,
  });

  factory Missao.fromMap(String id, Map<String, dynamic> dados) {
    return Missao(
      id: id,
      titulo: dados['titulo'] ?? '',
      grau: dados['grau'] ?? 0,
      concluida: dados['concluida'] ?? false,
      usuarioId: dados['usuarioId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'grau': grau,
      'concluida': concluida,
      'usuarioId': usuarioId,
    };
  }
}
