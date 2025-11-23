// Placeholder baseado na anotação @OneToOne
class PagamentosModel {
  final int? id;
  // Adicione outros campos de pagamento conforme a classe Java
  // Exemplo: final String? statusPagamento;

  PagamentosModel({this.id});

  factory PagamentosModel.fromJson(Map<String, dynamic> json) {
    return PagamentosModel(
      id: json['id'] as int?,
      // Mapeamento de outros campos
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}