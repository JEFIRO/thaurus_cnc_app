enum StatusPedido {
  LAYOUT_PENDING,
  PENDING_PAYMENT,
  IN_PRODUCTION,
  PREPARING_FOR_DELIVERY,
  ON_THE_WAY,
  CANCLED,
  DELIVERED,
}

class StatusPedidoAdapter {
  static StatusPedido? fromString(String? status) {
    if (status == null) return null;
    try {
      return StatusPedido.values.firstWhere(
        (e) => e.toString().split('.').last == status.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
