class FreteModel {
  final double valorFrete;
  final String metodo;

  FreteModel({
    required this.valorFrete,
    required this.metodo,
  });

  factory FreteModel.fromJson(Map<String, dynamic> json) {
    return FreteModel(
      valorFrete: (json['valor_frete'] as num).toDouble(),
      metodo: json['metodo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valor_frete': valorFrete,
      'metodo': metodo,
    };
  }
}