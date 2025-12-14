import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaurus_cnc/app_theme.dart';
import 'package:thaurus_cnc/model/pedido/pedido_item_model.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/model/pagamentos/status_pagamento.dart';
import 'package:thaurus_cnc/model/pedido/pedido_model.dart';
import 'package:thaurus_cnc/model/pedido/status_pedido.dart';

class PedidoDetalhePage extends StatelessWidget {
  final Future<PedidoModel> pedidoFuture;

  const PedidoDetalhePage({super.key, required this.pedidoFuture});

  @override
  Widget build(BuildContext context) {

    print("object");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Pedido"),
        backgroundColor: const Color(0xFF2B2B2B),
      ),
      backgroundColor: const Color(0xFF2B2B2B),

      body: FutureBuilder<PedidoModel>(
        future: pedidoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "❌ Erro ao buscar pedido: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return _PedidoDetalhePageContent(pedido: snapshot.data!);
          }

          return const Center(
            child: Text(
              "Nenhum dado de pedido encontrado.",
              style: TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}

class _PedidoDetalhePageContent extends StatelessWidget {
  final PedidoModel pedido;

  _PedidoDetalhePageContent({required this.pedido});

  Color _getStatusColor(StatusPedido? status) {
    if (status == null) return Colors.blueGrey;

    switch (status) {
      case StatusPedido.LAYOUT_PENDING:
        return Colors.deepPurpleAccent;

      case StatusPedido.PENDING_PAYMENT:
        return Colors.orange.shade700;

      case StatusPedido.IN_PRODUCTION:
        return Colors.amber.shade700;

      case StatusPedido.PREPARING_FOR_DELIVERY:
        return Colors.lightBlue.shade700;

      case StatusPedido.ON_THE_WAY:
        return Colors.blue.shade600;

      case StatusPedido.CANCLED:
        return Colors.red.shade600;

      case StatusPedido.DELIVERED:
        return Colors.green.shade600;

      default:
        return Colors.blueGrey;
    }
  }

  String _formatStatus(StatusPedido? status) {
    if (status == null) return "Desconhecido";

    switch (status) {
      case StatusPedido.LAYOUT_PENDING:
        return "LAYOUT PENDENTE";

      case StatusPedido.PENDING_PAYMENT:
        return "PENDENTE DE PAGAMENTO";

      case StatusPedido.IN_PRODUCTION:
        return "EM PRODUÇÃO";

      case StatusPedido.PREPARING_FOR_DELIVERY:
        return "PREPARANDO ENTREGA";

      case StatusPedido.ON_THE_WAY:
        return "A CAMINHO";

      case StatusPedido.CANCLED:
        return "CANCELADO";

      case StatusPedido.DELIVERED:
        return "CONCLUÍDO";
    }
  }

  String _formatStatusPagamento(StatusPagamento? status) {
    if (status == null) return "Desconhecido";

    switch (status) {
      case StatusPagamento.PENDING_PAYMENT:
        return "Aguardando pagamento";

      case StatusPagamento.PAYMENT_ENTRY:
        return "Entrada registrada";

      case StatusPagamento.PAYMENT_COMPLETED:
        return "Pagamento concluído";
    }
  }

  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  static const Color grafiteProfundo = Color(0xFF2B2B2B);
  static const Color cinzaEscuro = Color(0xFF3A3A3A);
  static const Color cinzaMedio = Color(0xFF8D8D8D);
  static const Color branco = Color(0xFFFFFFFF);

  Widget _buildDetailRow(
    String label,
    String value, {
    Color valueColor = branco,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 0,
            child: AutoSizeText(
              label,
              style: const TextStyle(color: cinzaMedio, fontSize: 14),
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 1,
            child: AutoSizeText(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: branco,
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildItemCard(PedidoItemModel item) {
    return _buildItemSection(item);
  }

  Widget _buildHeaderSection() {
    final statusColor = _getStatusColor(pedido.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withAlpha((255.0 * 0.5).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${pedido.id ?? 'N/A'}',
                style: const TextStyle(
                  color: branco,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((255.0 * 0.2).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatStatus(pedido.status).toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            "ID UUID ",
            pedido.idPedido ?? 'N/A',
            valueColor: cinzaMedio,
          ),
          _buildDetailRow(
            "Data/Hora",
            pedido.dataPedido != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(pedido.dataPedido!)
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final subtotal = pedido.itens.fold(
      0.0,
      (sum, item) => sum + (item.valor * item.quantidade),
    );
    final freteValor = pedido.frete?.valorFrete ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow("Subtotal Itens", _currencyFormat.format(subtotal)),
          _buildDetailRow("Frete", _currencyFormat.format(freteValor)),
          _buildDetailRow("(${pedido.frete?.metodo ?? 'Não Definido'})", ""),
          const Divider(color: Colors.white12, height: 20),
          _buildDetailRow(
            "Valor Total ",
            _currencyFormat.format(pedido.valorTotal ?? subtotal + freteValor),
            valueColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildItemSection(PedidoItemModel item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.nomeProduto,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.branco,
            ),
          ),

          const SizedBox(height: 8),
          _buildDetailRow(
            "Valor ",
            "R\$ ${(item.variante?.valor ?? 0).toStringAsFixed(2)}",
          ),

          const SizedBox(height: 8),

          Text(
            "Medidas do Produto",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.branco,
            ),
          ),
          _buildDetailRow(
            "Altura ",
            '${item.variante?.medidaProduto.altura} Cm',
          ),
          _buildDetailRow(
            "Largura ",
            '${item.variante?.medidaProduto.largura} Cm',
          ),
          SizedBox(height: 8),
          Text(
            "Personalização",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.branco,
            ),
          ),
          SizedBox(height: 8),
          _buildPersonalizacaoSection(item.personalizacao),
        ],
      ),
    );
  }

  Widget _buildPersonalizacaoSection(Map<String, dynamic> personalizacao) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(personalizacao.length, (i) {
          final chave = personalizacao.keys.elementAt(i);
          final valor = personalizacao.values.elementAt(i);
          return _buildDetailRow(chave, valor.toString());
        }),
      ],
    );
  }

  Widget _buildClientSection(ClienteModel cliente) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Nome ", cliente.nome!),
          _buildDetailRow("Telefone ", cliente.telefone!),
          _buildDetailRow("Email ", cliente.email!),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    final pagamentoId = pedido.pagamentos?.id;

    final pagamento = pedido.pagamentos!;

    final statusColor = (pagamentoId != null)
        ? Colors.lightBlueAccent
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  'ID do Pagamento #${pagamento.id}',
                  style: const TextStyle(
                    color: branco,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((255.0 * 0.2).round()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Expanded(
                  child: AutoSizeText(
                    _formatStatusPagamento(pagamento.status).toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          _buildDetailRow(
            "Uuid ",
            pedido.pagamentos!.idPagamento.toString(),
            valueColor: statusColor,
          ),

          _buildDetailRow("Valor a pagar ", "R\$ ${pagamento.valorRestante}"),
          _buildDetailRow("Valor a pago ", "R\$ ${pagamento.valorPago}"),
          _buildDetailRow("Valor a Total ", "R\$ ${pagamento.valorTotal}"),

          _buildDetailRow(
            "Data/Hora ",
            pedido.dataPedido != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(pagamento.dataCadastro!)
                : 'N/A',
          ),
        ],
      ),
    );
  }

  // Widget _buildPaymentSection()
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 20),

          _buildTotalSection(),
          const SizedBox(height: 25),

          _buildSectionTitle("👤 Cliente"),
          if (pedido.cliente != null) _buildClientSection(pedido.cliente!),
          const SizedBox(height: 25),

          _buildSectionTitle("📦 Itens (${pedido.itens.length})"),
          ...pedido.itens.map((item) => _buildItemCard(item)),
          const SizedBox(height: 25),

          _buildSectionTitle("💳 Pagamento"),
          _buildPaymentSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
