import 'package:thaurus_cnc/model/Produto/medida_model.dart';

class Variante {
  int? id;
  double valor;
  MedidaModel medidaProduto;
  MedidaModel medidaEmbalagem;

  Variante({
    this.id,
    required this.valor,
    required this.medidaProduto,
    required this.medidaEmbalagem,
  });

  factory Variante.fromJson(Map<String, dynamic> json) {
    return Variante(
      id: json["id"] != null ? int.tryParse(json["id"].toString()) : null,
      valor: double.tryParse(json["valor"]?.toString() ?? '0') ?? 0.0,
      medidaProduto: json["medida_produto"] != null
          ? MedidaModel.fromJson(json["medida_produto"])
          : MedidaModel(altura: 0, largura: 0, profundidade: 0, peso: 0),

      medidaEmbalagem: json["medida_embalagem"] != null
          ? MedidaModel.fromJson(json["medida_embalagem"])
          : MedidaModel(altura: 0, largura: 0, profundidade: 0, peso: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "valor": valor,
      "medida_produto": medidaProduto.toJson(),
      "medida_embalagem": medidaEmbalagem.toJson(),
    };
  }
}
