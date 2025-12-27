import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/service/frete_service.dart';

import '../../model/frete/calcula_frete.dart';
import '../../model/item_request.dart';

class FreteOption extends StatefulWidget {
  List<ItemRequest> listItemRequest = [];
  ClienteModel cliente;
  String cep;

  FreteOption({
    super.key,
    required this.listItemRequest,
    required this.cliente,
    required this.cep
  });

  @override
  State<FreteOption> createState() => _FreteOptionState();
}

class _FreteOptionState extends State<FreteOption> {

  _buscarTransportadora() {
    var cliente = widget.cliente;
    var listItemRequest = widget.listItemRequest;

    List<CalculaFrete> request = listItemRequest.map((v) =>
        CalculaFrete(id_Produto: v.produto_id,
            id_variante: v.variante_id,
            quantidade: v.quantidade)).toList();

    if (widget.cliente != null) {
      FreteService().calulaFrete(cliente.endereco!.cep!, request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        ),
      ),
    );
  }
}
