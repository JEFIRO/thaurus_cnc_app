import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../PedidoItem.dart';
import '../cliente/ClienteModel.dart';
import 'PedidoModel.dart';
import 'StatusPedido.dart';
class DetalhesPedidoPage extends StatelessWidget {
  final Future<PedidoModel> pedidoFuture;

  const DetalhesPedidoPage({super.key, required this.pedidoFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Pedido"),
        backgroundColor: const Color(0xFF2B2B2B),
      ),
      backgroundColor: const Color(0xFF2B2B2B),

      body: FutureBuilder<PedidoModel>(
        future: pedidoFuture,
        builder: (context, snapshot) {

          // 1. Estado de Erro
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "❌ Erro ao buscar pedido: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // 2. Estado de Carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          // 3. ESTADO DE DADOS PRONTOS (SUCCESS)
          if (snapshot.hasData && snapshot.data != null) {
            // Chama o widget de exibição do conteúdo final
            return _DetalhesPedidoPageContent(pedido: snapshot.data!);
          }

          // 4. Estado Vazio
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

class _DetalhesPedidoPageContent extends StatelessWidget {
  final PedidoModel pedido;

  _DetalhesPedidoPageContent({required this.pedido});

  // --- Funções Auxiliares (Adapte-as para usar suas classes reais) ---

  Color _getStatusColor(StatusPedido? status) {
    if (status == null) return Colors.blueGrey;
    switch (status) {
      case StatusPedido.IN_PRODUCTION: return Colors.amber.shade700;
      case StatusPedido.COMPLETED: return Colors.green.shade600;
      case StatusPedido.CANCELED: return Colors.red.shade600;
      default: return Colors.blueGrey;
    }
  }

  String _formatStatus(StatusPedido? status) {
    if (status == null) return "Desconhecido";
    switch (status) {
      case StatusPedido.IN_PRODUCTION: return "EM PRODUÇÃO";
      case StatusPedido.COMPLETED: return "CONCLUÍDO";
      case StatusPedido.CANCELED: return "CANCELADO";
      case StatusPedido.LAYOUT_PENDING: return "LAYOUT PENDENTE";
    }
  }

  final _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // Estilos base
  static const Color grafiteProfundo = Color(0xFF2B2B2B);
  static const Color cinzaEscuro = Color(0xFF3A3A3A);
  static const Color cinzaMedio = Color(0xFF8D8D8D);
  static const Color branco = Color(0xFFFFFFFF);

  // Widget de linha de detalhe
  Widget _buildDetailRow(String label, String value, {Color valueColor = branco}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: cinzaMedio, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w500, fontSize: 15)),
        ],
      ),
    );
  }

  // Widget de título de seção
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

  // Widget para Item Card (Necessita que PedidoItem e MedidaModel estejam definidos)
  Widget _buildItemCard(PedidoItem item) {
    // Implementação do Card do Item
    return const Card(color: cinzaEscuro, child: Padding(padding: EdgeInsets.all(16), child: Text("Detalhes do Item")));
  }

  // Widget para Cabeçalho
  Widget _buildHeaderSection() {
    final statusColor = _getStatusColor(pedido.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cinzaEscuro,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.5)),
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
                    color: branco, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
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
          _buildDetailRow("ID UUID", pedido.idPedido ?? 'N/A', valueColor: cinzaMedio),
          _buildDetailRow("Data/Hora", pedido.dataPedido != null ? DateFormat('dd/MM/yyyy HH:mm').format(pedido.dataPedido!) : 'N/A'),
        ],
      ),
    );
  }

  // Widget para Valores Totais (Necessita de FreteModel)
  Widget _buildTotalSection() {
    final subtotal = pedido.itens.fold(0.0, (sum, item) => sum + (item.valor * item.quantidade));
    final freteValor = pedido.frete?.valorFrete ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cinzaEscuro, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        _buildDetailRow("Subtotal Itens", _currencyFormat.format(subtotal)),
        _buildDetailRow("Frete (${pedido.frete?.metodo ?? 'Não Definido'})", _currencyFormat.format(freteValor)),
        const Divider(color: Colors.white12, height: 20),
        _buildDetailRow("Valor Total", _currencyFormat.format(pedido.valorTotal ?? subtotal + freteValor), valueColor: Colors.greenAccent),
      ],),
    );
  }

  // Widget para Cliente (Necessita de ClienteModel)
  Widget _buildClientSection(ClienteModel cliente) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cinzaEscuro, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildDetailRow("Nome", cliente.nome!),
        _buildDetailRow("Telefone", cliente.telefone!),
        _buildDetailRow("Email", cliente.email!),
      ],),
    );
  }

  // Widget para Pagamento
  Widget _buildPaymentSection() {
    final pagamentoId = pedido.pagamentos?.id;
    final statusColor = (pagamentoId != null) ? Colors.lightBlueAccent : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cinzaEscuro, borderRadius: BorderRadius.circular(12)),
      child: _buildDetailRow("ID do Pagamento", pagamentoId?.toString() ?? 'Não Iniciado', valueColor: statusColor),
    );
  }


  // --- Método Build Principal do Conteúdo ---
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
          ...pedido.itens.map((item) => _buildItemCard(item)).toList(),
          const SizedBox(height: 25),

          _buildSectionTitle("💳 Pagamento"),
          _buildPaymentSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}