class DadosPagamento {
  int? id;
  String? idPagamento;
  String? transactionNsu;
  String? reciboCliente;
  String? formaPagamento;
  DateTime? dataPagamento;
  double? valorPago;
  String? recibo;

  DadosPagamento({
    this.id,
    this.idPagamento,
    this.transactionNsu,
    this.reciboCliente,
    this.formaPagamento,
    this.dataPagamento,
    this.valorPago,
    this.recibo,
  });

  factory DadosPagamento.fromJson(Map<String, dynamic> json) {
    return DadosPagamento(
      id: json['id'],
      idPagamento: json['id_pagamento'],
      transactionNsu: json['transaction_nsu'],
      reciboCliente: json['reciboCliente'],
      formaPagamento: json['formaPagamento'],
      dataPagamento: json['dataPagamento'] != null
          ? DateTime.parse(json['dataPagamento'])
          : null,
      valorPago: (json['valorPago'] as num?)?.toDouble(),
      recibo: json['recibo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pagamento': idPagamento,
      'transaction_nsu': transactionNsu,
      'reciboCliente': reciboCliente,
      'formaPagamento': formaPagamento,
      'dataPagamento': dataPagamento?.toIso8601String(),
      'valorPago': valorPago,
      'recibo': recibo,
    };
  }
}
