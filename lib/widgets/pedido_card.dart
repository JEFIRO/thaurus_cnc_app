import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thaurus_cnc/model/pedido/pedido_model.dart';
import 'package:thaurus_cnc/model/pedido/pedido_resumo_model.dart';
import 'package:thaurus_cnc/screens/pedido/pedido_detalhe_page.dart';
import 'package:thaurus_cnc/service/pedido_service.dart';

class PedidoCard extends StatelessWidget {
  final PedidoResumoModel pedidoResumoModel;

  PedidoCard({super.key, required this.pedidoResumoModel});

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower == "in_production") return Colors.amber.shade700;
    if (statusLower == "completed") return Colors.green.shade600;
    if (statusLower == "canceled") return Colors.red.shade600;
    return Colors.blueGrey;
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case "IN_PRODUCTION":
        return "EM PRODUÇÃO";
      case "COMPLETED":
        return "CONCLUÍDO";
      case "CANCELED":
        return "CANCELADO";
      default:
        return status.replaceAll('_', ' ');
    }
  }

  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    const cardBackgroundColor = Color(0xFF3A3A3A);
    const textColorPrimary = Colors.white;
    const textColorSecondary = Colors.white70;
    const dividerColor = Colors.white12;

    final pedido = pedidoResumoModel;
    final statusColor = _getStatusColor(pedido.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: cardBackgroundColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1.0),
      ),
      child: InkWell(
        onTap: () async {
          Future<PedidoModel> pedidoResponseFuture = PedidoService().getPedido(
            pedido.pedidoId,
          );

          final pedidos = await pedidoResponseFuture;

          print(pedidos.toString());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PedidoDetalhePage(pedido: pedidos),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido #${pedido.pedidoId}',
                    style: const TextStyle(
                      color: textColorPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _formatStatus(pedido.status).toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(color: dividerColor, height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valor Total',
                        style: TextStyle(
                          color: textColorSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currencyFormat.format(pedido.valorTotal),
                        style: const TextStyle(
                          color: textColorPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Data do Pedido',
                        style: TextStyle(
                          color: textColorSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(pedido.dataPedido),
                        style: const TextStyle(
                          color: textColorPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildDetailRow(
                Icons.person_outline,
                'Cliente',
                pedido.clienteNome,
                textColorPrimary,
                textColorSecondary,
              ),
              _buildDetailRow(
                Icons.phone_outlined,
                'Telefone',
                pedido.clienteTelefone,
                textColorPrimary,
                textColorSecondary,
              ),

              const SizedBox(height: 20),

              Text(
                'Item Principal',
                style: TextStyle(
                  color: textColorSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (pedido.imagem.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        pedido.imagem,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: textColorSecondary),
                      ),
                    ),
                  if (pedido.imagem.isNotEmpty) const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${pedido.quantidadeItens}x ${pedido.produtoNome}',
                      style: const TextStyle(
                        color: textColorPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String title,
    String value,
    Color valueColor,
    Color titleColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: titleColor.withOpacity(0.8), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: titleColor, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
