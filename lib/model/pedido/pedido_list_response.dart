import 'pedido_resumo_model.dart';

class PedidoListResponse {
  final List<PedidoResumoModel> content;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;
  final bool first;
  final bool last;
  final int numberOfElements;
  final bool empty;

  PedidoListResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.first,
    required this.last,
    required this.numberOfElements,
    required this.empty,
  });

  factory PedidoListResponse.fromJson(Map<String, dynamic> json) {
    final contentList = (json['content'] as List<dynamic>)
        .map((item) => PedidoResumoModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return PedidoListResponse(
      content: contentList,
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int,
      first: json['first'] as bool,
      last: json['last'] as bool,
      numberOfElements: json['numberOfElements'] as int,
      empty: json['empty'] as bool,
    );
  }
}
