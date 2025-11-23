import '../Variante.dart';

class ProdutoModel {
  int? id;
  late String nome;
  late String descricao;
  late String imagem;
  late bool ativo;
  late List<Variante> variantes;
  late Map<String, dynamic> personalizacao;

  ProdutoModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.ativo,
    required this.variantes,
    required this.personalizacao,
  });

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json["id"] != null ? int.tryParse(json["id"].toString()) : null,
      nome: json["nome"] ?? '',
      descricao: json["descricao"] ?? '',
      imagem: json["imagem"] ?? '',
      ativo: json["ativo"] ?? true,
      variantes: json["variantes"] != null
          ? List<Variante>.from(
          json["variantes"].map((v) => Variante.fromJson(v)))
          : [],
      personalizacao: json["personalizacao"] != null
          ? Map<String, dynamic>.from(json["personalizacao"])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "nome": nome,
      "descricao": descricao,
      "imagem": imagem,
      "ativo": ativo,
      "variantes": variantes.map((v) => v.toJson()).toList(),
      "personalizacao": personalizacao,
    };
  }
}
