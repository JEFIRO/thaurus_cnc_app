enum StatusPedido {
  LAYOUT_PENDING,
  IN_PRODUCTION,
  COMPLETED,
  CANCELED,
}

class StatusPedidoAdapter {
  static StatusPedido? fromString(String? status) {
    if (status == null) return null;
    try {
      return StatusPedido.values.firstWhere(
              (e) => e.toString().split('.').last == status.toUpperCase());
    } catch (_) {
      return null;
    }
  }
}