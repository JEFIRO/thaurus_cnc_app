import 'package:thaurus_cnc/model/cliente/cliente_model.dart';

import '../item_request.dart';
import 'frete_model.dart';

class PedidoRequest {
  ClienteModel cliente;
  List<ItemRequest> itens;
  FreteModel frete;

  PedidoRequest({
    required this.cliente,
    required this.itens,
    required this.frete,
  });

  Map<String, dynamic> toJson() {
    return {'cliente': cliente, 'itens': itens, 'frete': frete};
  }
}
