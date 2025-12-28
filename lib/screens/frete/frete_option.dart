import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/model/pedido/frete_model.dart';
import 'package:thaurus_cnc/model/pedido/pedido_request.dart';
import 'package:thaurus_cnc/routes.dart';
import 'package:thaurus_cnc/service/frete_service.dart';
import 'package:thaurus_cnc/service/pedido_service.dart';

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
    required this.cep,
  });

  @override
  State<FreteOption> createState() => _FreteOptionState();
}

class _FreteOptionState extends State<FreteOption> {
  int selectedIndex = -1;
  bool isSelectedd = false;
  FreteModel? freteSelecionado;

  String mapOptions = "";
  List<Map<String, dynamic>> listaFiltrada = [];

  _buscarTransportadora() async {
    var cliente = widget.cliente;
    var listItemRequest = widget.listItemRequest;

    List<CalculaFrete> request = listItemRequest
        .map(
          (v) => CalculaFrete(
            id_Produto: v.produto_id,
            id_variante: v.variante_id,
            quantidade: v.quantidade,
          ),
        )
        .toList();

    if (cliente != null) {
      String? resposta = await FreteService().calulaFrete(widget.cep, request);
      if (resposta != null) {
        setState(() {
          mapOptions = resposta;
          listaFiltrada = aaa().where((item) => item['name'] != null).toList();
        });
      }
    }
  }

  void _enviarPedido() async {
    if (freteSelecionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error')));
    }
    PedidoRequest pedido = PedidoRequest(
      cliente: widget.cliente,
      itens: widget.listItemRequest,
      frete: freteSelecionado!,
    );

    bool pedidoResponse = await PedidoService().criarProduto(pedido);

    if (pedidoResponse) {
      Navigator.pushNamed(context, Routes.orderPage);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error')));
    }
  }

  List<Map<String, dynamic>> aaa() {
    final List<dynamic> lista = jsonDecode(mapOptions);
    List<Map<String, dynamic>> listaMapas = lista
        .map((e) => e as Map<String, dynamic>)
        .toList();
    return listaMapas;
  }

  @override
  void initState() {
    super.initState();
    _buscarTransportadora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Opções de envio",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listaFiltrada.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedIndex == index;
                        var item = listaFiltrada[index];

                        String nome = item['name'];
                        String preco = item['price']?.toString() ?? "0";
                        String tempoEntrega =
                            item['delivery_time']?.toString() ?? "-";
                        String transportadora =
                            item['company']?['name'] ?? "Desconhecida";
                        String logoTransportadora =
                            item['company']?['picture'] ?? "";

                        return _cardOption(
                          nome,
                          transportadora,
                          logoTransportadora,
                          preco,
                          tempoEntrega,
                          isSelected,
                          index,
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (isSelectedd == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Escolha um opção'),
                                  ),
                                );
                              }

                              _enviarPedido();
                            },
                            child: Text(
                              "Confirmar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card _cardOption(
    String categoria,
    tranportadora,
    logoTranpostadora,
    price,
    diasEntrega,
    bool isSelected,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
      color: Color(0xFF0C3F57),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
      ),

      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
            isSelectedd = true;
            freteSelecionado = FreteModel(
              valorFrete: double.parse(price),
              metodo: categoria,
            );
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsetsGeometry.all(4),
                    width: 60,
                    height: 60,
                    color: Colors.white24,
                    child: Image.network(
                      logoTranpostadora,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categoria,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "$tranportadora * Entrega em $diasEntrega dias úteis",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  "R\$ $price",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
