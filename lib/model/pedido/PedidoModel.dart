import 'package:thaurus_cnc/model/cliente/ClienteModel.dart';
import '../FreteModel.dart';

import 'PagamentosModel.dart'; // Importe a nova classe
import '../PedidoItem.dart';
import 'StatusPedido.dart';

class PedidoModel {
  final int? id;
  final String? idPedido; // Corresponde a 'id_Pedido'
  final ClienteModel? cliente;
  final List<PedidoItem> itens;
  final double? valorTotal; // Corresponde a 'valor_total'
  final double? valorCustomizacao; // Corresponde a 'valor_customizacao'
  final StatusPedido? status;
  final FreteModel? frete;
  final PagamentosModel? pagamentos; // Corresponde a 'pagamentos'
  final DateTime? dataPedido; // Corresponde a 'data_pedido'
  final DateTime? dataFinalizacao; // Corresponde a 'data_finalizacao'
  final bool ativo;

  PedidoModel({
    required this.id,
    required this.idPedido,
    required this.cliente,
    required this.itens,
    required this.valorTotal,
    required this.valorCustomizacao,
    required this.status,
    required this.frete,
    required this.pagamentos,
    required this.dataPedido,
    required this.dataFinalizacao,
    required this.ativo,
  });


  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json['id'] as int?,
      idPedido: json['id_Pedido'] as String?, // Mapeamento direto

      cliente: json['cliente'] != null
          ? ClienteModel.fromJson(json['cliente'])
          : null,

      itens: json['itens'] != null
          ? List<PedidoItem>.from(
        json['itens'].map((item) => PedidoItem.fromJson(item)),
      )
          : [],

      valorTotal: json['valor_total'] != null
          ? (json['valor_total'] as num).toDouble()
          : null,

      valorCustomizacao: json['valor_customizacao'] != null
          ? (json['valor_customizacao'] as num).toDouble()
          : null,

      status: StatusPedidoAdapter.fromString(json['status'] as String?),

      frete: json['frete'] != null
          ? FreteModel.fromJson(json['frete'])
          : null,

      pagamentos: json['pagamentos'] != null // Mapeamento do PagamentosModel
          ? PagamentosModel.fromJson(json['pagamentos'])
          : null,

      dataPedido: json['data_pedido'] != null
          ? DateTime.tryParse(json['data_pedido'])
          : null,

      dataFinalizacao: json['data_finalizacao'] != null
          ? DateTime.tryParse(json['data_finalizacao'])
          : null,

      ativo: json['ativo'] as bool? ?? false, // Mapeamento do 'boolean ativo'
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_Pedido': idPedido,
      'cliente': cliente?.toJson(),
      'itens': itens.map((item) => item.toJson()).toList(),
      'valor_total': valorTotal,
      'valor_customizacao': valorCustomizacao,
      'status': status?.toString().split('.').last,
      'frete': frete?.toJson(),
      'pagamentos': pagamentos?.toJson(),
      'data_pedido': dataPedido?.toIso8601String(),
      'data_finalizacao': dataFinalizacao?.toIso8601String(),
      'ativo': ativo,
    };
  }
}