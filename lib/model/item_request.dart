class ItemRequest {
  int produto_id;
  int variante_id;
  Map<String, dynamic> personalizacao;
  int quantidade;

  ItemRequest({
    required this.produto_id,
    required this.variante_id,
    required this.personalizacao,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'produto_id': produto_id,
      'variante_id': variante_id,
      'personalizacao': personalizacao,
      'quantidade': quantidade,
    };
  }
}
