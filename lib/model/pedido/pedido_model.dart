import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/model/pedido/frete_model.dart';
import 'package:thaurus_cnc/model/pagamentos/pagamento_model.dart';
import 'package:thaurus_cnc/model/pedido/pedido_item_model.dart';
import 'package:thaurus_cnc/model/pedido/status_pedido.dart';

class PedidoModel {
  final int? id;
  final String? idPedido;
  final ClienteModel? cliente;
  final List<PedidoItemModel> itens;
  final double? valorTotal;
  final double? valorCustomizacao;
  final StatusPedido? status;
  final FreteModel? frete;
  final PagamentosModel? pagamentos;
  final DateTime? dataPedido;
  final DateTime? dataFinalizacao;
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
    print(json['pagamento']);
    return PedidoModel(
      id: json['id'] as int?,
      idPedido: json['id_Pedido'] as String?,

      cliente: json['cliente'] != null
          ? ClienteModel.fromJson(json['cliente'])
          : null,

      itens: json['itens'] != null
          ? List<PedidoItemModel>.from(
              json['itens'].map((item) => PedidoItemModel.fromJson(item)),
            )
          : [],
      valorTotal: json['valor_total'] != null
          ? (json['valor_total'] as num).toDouble()
          : null,

      valorCustomizacao: json['valor_customizacao'] != null
          ? (json['valor_customizacao'] as num).toDouble()
          : null,

      status: StatusPedidoAdapter.fromString(json['status'] as String?),
      frete: json['frete'] != null ? FreteModel.fromJson(json['frete']) : null,

    //  pagamentos: PagamentosModel(dadosPagamentos: []),

      pagamentos: json['pagamento'] != null
          ? PagamentosModel.fromJson(json['pagamento'])
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
