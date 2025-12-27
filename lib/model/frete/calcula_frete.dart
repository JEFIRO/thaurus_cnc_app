class CalculaFrete {
  int id_Produto;
  int id_variante;
  int quantidade;

  CalculaFrete({
    required this.id_Produto,
    required this.id_variante,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_Produto': id_Produto,
      'id_variante': id_variante,
      'quantidade': quantidade,
    };
  }
}
