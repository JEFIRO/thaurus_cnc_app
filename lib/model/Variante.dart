import 'Produto/Medida.dart';

class Variante {
  int? id;
  double valor;
  Medida medida_produto;
  Medida medida_embalagem;

  Variante({
    this.id,
    required this.valor,
    required this.medida_produto,
    required this.medida_embalagem,
  });

  factory Variante.fromJson(Map<String, dynamic> json) {
    return Variante(
      id: json["id"] != null ? int.tryParse(json["id"].toString()) : null,
      valor: double.tryParse(json["valor"]?.toString() ?? '0') ?? 0.0,
      medida_produto: json["medida_produto"] != null
          ? Medida.fromJson(json["medida_produto"])
          : Medida(altura: 0, largura: 0, profundidade: 0, peso: 0),

      medida_embalagem: json["medida_embalagem"] != null
          ? Medida.fromJson(json["medida_embalagem"])
          : Medida(altura: 0, largura: 0, profundidade: 0, peso: 0),

    );
  }


  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "valor": valor,
      "medida_produto": medida_produto.toJson(),
      "medida_embalagem": medida_embalagem.toJson(),
    };
  }
}
