import 'package:flutter/material.dart';
import 'package:thaurus_cnc/Widgets/SearchFilterSortAppBar.dart';

import '../../Widgets/PedidoCard.dart';
import '../../service/PedidoService.dart';
import 'PedidoResumoModel.dart';

class Pedidoview extends StatefulWidget {
  const Pedidoview({super.key});

  @override
  State<Pedidoview> createState() => _PedidoviewState();
}

class _PedidoviewState extends State<Pedidoview> {
  List<PedidoResumoModel> pedidos = [];
  List<PedidoResumoModel> pedidosFiltrados = [];
  bool carregando = true;

  final Map<String, String> _statusMapping = const {
    "Em andamento": "IN_PRODUCTION",
    "Concluído": "COMPLETED",
    "Cancelado": "CANCELED",
  };

  @override
  void initState() {
    super.initState();
    buscarPedidos();
  }

  Future<void> buscarPedidos() async {
    try {
      var dados = await Pedidoservice().listarPedidos();
      setState(() {
        pedidos = dados;
        pedidosFiltrados = List.from(pedidos);
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      debugPrint("Erro ao buscar pedidos: $e");
    }
  }

  void onSearchChanged(String termo) {
    setState(() {
      termo = termo.toLowerCase();
      pedidosFiltrados = pedidos.where((pedido) {

        final cliente = pedido.clienteNome.toLowerCase();
        final status = pedido.status.toLowerCase();
        final telefone = pedido.clienteTelefone.replaceAll(" ", "");
        final id = pedido.pedidoId.toString();
        final produto = pedido.produtoNome.toLowerCase();

        return cliente.contains(termo) ||
            status.contains(termo) ||
            telefone.contains(termo) ||
            id.contains(termo) ||
            produto.contains(termo);
      }).toList();
    });
  }

  void onFilterChanged(String filtro) {
    setState(() {
      if (filtro == "Todos") {
        pedidosFiltrados = List.from(pedidos);
      } else {
        final apiStatus = _statusMapping[filtro];

        pedidosFiltrados = pedidos
            .where((pedido) => pedido.status.toUpperCase() == apiStatus)
            .toList();
      }
    });
  }

  void onSortChanged(String criterio) {
    setState(() {
      switch (criterio) {
        case "Data":
          pedidosFiltrados.sort((a, b) => b.dataPedido.compareTo(a.dataPedido));
          break;
        case "Valor":
          pedidosFiltrados.sort((a, b) => b.valorTotal.compareTo(a.valorTotal));
          break;
        case "Cliente":
          pedidosFiltrados.sort((a, b) => a.clienteNome.compareTo(b.clienteNome));
          break;
        case "ID":
          pedidosFiltrados.sort((a, b) => a.pedidoId.compareTo(b.pedidoId));
          break;
      }
    });
  }

  final filtros = const ["Todos", "Em andamento", "Concluído", "Cancelado"];
  final ordenacoes = const ["Data", "Valor", "Cliente", "ID"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: SearchFilterSortAppBar(
        onSearchChanged: onSearchChanged,
        onFilterChanged: onFilterChanged,
        onSortChanged: onSortChanged,
        filtros: filtros,
        ordenacoes: ordenacoes,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : pedidosFiltrados.isEmpty
          ? const Center(
        child: Text(
          "Nenhum pedido encontrado",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        itemCount: pedidosFiltrados.length,
        itemBuilder: (context, index) {
          final pedido = pedidosFiltrados[index];

          return PedidoCard(pedidoResumoModel: pedido);
        },
      ),
    );
  }
}