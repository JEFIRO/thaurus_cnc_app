class PedidoResumoModel {
  final String status;
  final double valorTotal;
  final String imagem;
  final bool ativo;
  final int pedidoId;
  final String idPedido;
  final int clienteId;
  final String clienteNome;
  final String clienteTelefone;
  final String clienteEmail;
  final String produtoNome;
  final int quantidadeItens;
  final DateTime dataPedido;
  final String linkDetalhes;

  PedidoResumoModel({
    required this.status,
    required this.valorTotal,
    required this.imagem,
    required this.ativo,
    required this.pedidoId,
    required this.idPedido,
    required this.clienteId,
    required this.clienteNome,
    required this.clienteTelefone,
    required this.clienteEmail,
    required this.produtoNome,
    required this.quantidadeItens,
    required this.dataPedido,
    required this.linkDetalhes,
  });

  // Método de fábrica para criar uma instância a partir de um JSON (Map)
  factory PedidoResumoModel.fromJson(Map<String, dynamic> json) {
    return PedidoResumoModel(
      status: json['status'] as String,
      valorTotal: (json['valorTotal'] as num).toDouble(),
      imagem: json['imagem'] as String,
      ativo: json['ativo'] as bool,
      pedidoId: json['pedidoId'] as int,
      idPedido: json['idPedido'] as String,
      clienteId: json['clienteId'] as int,
      clienteNome: json['clienteNome'] as String,
      clienteTelefone: json['clienteTelefone'] as String,
      clienteEmail: json['clienteEmail'] as String,
      produtoNome: json['produtoNome'] as String,
      quantidadeItens: json['quantidadeItens'] as int,
      // Converte a string de data/hora para um objeto DateTime
      dataPedido: DateTime.parse(json['dataPedido'] as String),
      linkDetalhes: json['linkDetalhes'] as String,
    );
  }
}