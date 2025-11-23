
import 'Variante.dart';

class PedidoItem {
  final int idItem; // Corresponde a 'id_item'
  final int idProduto; // Mapeado do DTO/JSON ('id_produto')
  final String nomeProduto; // Mapeado do DTO/JSON ('nome_Produto')
  final Variante? variante; // Corresponde ao relacionamento ManyToOne 'variante'

  // Corresponde ao Map<String, Object> personalizacao do Java
  final Map<String, dynamic> personalizacao;

  final int quantidade; // Corresponde a 'quantidade'
  final double valor; // Corresponde a 'valor' (Total do item)

  PedidoItem({
    required this.idItem,
    required this.idProduto,
    required this.nomeProduto,
    required this.variante,
    required this.personalizacao,
    required this.quantidade,
    required this.valor,
  });

  // --- Deserialização (Receber dados da API) ---
  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      // Mapeamento das chaves do JSON (snake_case para camelCase em Dart)
      idItem: json['id_item'] as int,
      idProduto: json['id_produto'] as int,
      nomeProduto: json['nome_Produto'] as String,

      // Mapeamento da Variante
      variante: json['variante'] != null
          ? Variante.fromJson(json['variante'] as Map<String, dynamic>)
          : null,

      // Mapeamento da Personalização (MapToJsonConverter -> Map<String, dynamic>)
      // Garantimos que seja um Map, mesmo que venha nulo.
      personalizacao: (json['personalizacao'] as Map<String, dynamic>?) ?? {},

      quantidade: json['quantidade'] as int,
      valor: (json['valor'] as num).toDouble(),
    );
  }

  // --- Serialização (Enviar dados para a API) ---
  Map<String, dynamic> toJson() {
    return {
      // Usando snake_case para o backend, como na sua classe Java
      'id_item': idItem,
      'id_produto': idProduto,
      'nome_Produto': nomeProduto,
      'variante': variante?.toJson(),
      'personalizacao': personalizacao,
      'quantidade': quantidade,
      'valor': valor,
    };
  }
}