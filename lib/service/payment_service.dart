import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/pagamentos/pagamento_model.dart';

class PaymentService {
  final String baseUrl = 'https://www.thauruscnc.com.br/api/pagamentos';

  Future<PagamentosModel> pagarPedido(int id, Map<String, dynamic> obj) async {
    final uri = Uri.parse('$baseUrl/$id');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obj),
    );
    print(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return PagamentosModel.fromJson(data);
    } else {
      throw Exception('Erro ao realizar pagamento');
    }
  }
}
