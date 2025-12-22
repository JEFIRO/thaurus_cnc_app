import 'package:thaurus_cnc/model/pagamentos/dados_pagamento_model.dart';
import 'package:thaurus_cnc/model/pagamentos/status_pagamento.dart';

import 'metodo_pagamento.dart';

class PagamentosModel {
  int? id;
  String? idPagamento;
  int? pedido;
  String? pedidoUuid;
  double? valorPago;
  double? valorRestante;
  double? valorTotal;
  StatusPagamento? status;
  String? observacao;
  DateTime? dataCadastro;
  MetodoPagamento? metodoPagamento;

  PagamentosModel({
    this.id,
    this.idPagamento,
    this.pedido,
    this.pedidoUuid,
    this.valorRestante,
    this.valorTotal,
    this.valorPago,
    this.status,
    this.observacao,
    this.dataCadastro,
    this.metodoPagamento,
  });

  factory PagamentosModel.fromJson(Map<String, dynamic> json) {
    return PagamentosModel(
      id: json['id'],
      idPagamento: json['id_pagamento'],
      pedido: json['pedido'],
      pedidoUuid: json['pedido_uuid'],
      valorRestante: (json['valorRestante'] as num?)?.toDouble(),
      valorTotal: (json['valorTotal'] as num?)?.toDouble(),
      valorPago: json['valorPago'] ?? 0.00,
      status: json['status'] != null
          ? StatusPagamento.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
            )
          : null,
      observacao: json['observacao'],
      dataCadastro: json['data_cadastro'] != null
          ? DateTime.parse(json['data_cadastro'])
          : null,
      metodoPagamento: MetodoPagamento.values.firstWhere(
            (e) => e.name == json['metodoPagamento'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pagamento': idPagamento,
      'pedido': pedido,
      'pedido_uuid': pedidoUuid,
      'valorRestante': valorRestante,
      'valorTotal': valorTotal,
      'valorPago': valorPago,
      'status': status?.toString().split('.').last,
      'observacao': observacao,
      'data_cadastro': dataCadastro?.toIso8601String(),
    };
  }
}
