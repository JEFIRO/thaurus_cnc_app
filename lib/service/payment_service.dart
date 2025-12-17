import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentService {
  final String baseUrl = 'https://www.thauruscnc.com.br/api/payment/link/';

  Future<String> linkPayment(int id, double valorAdicinal) async {
    final uri = Uri.parse(baseUrl).replace(
      pathSegments: [
        ...Uri.parse(baseUrl).pathSegments,
        id.toString(),
        valorAdicinal.toStringAsFixed(2),
      ],
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['url'];
    }

    return uri.toString();
  }

  Future<bool> enviarLink(Map<String, dynamic> obj) async {
    final String url = "https://thaurus-cnc-n8n.1o2rzn.easypanel.host/webhook/LembretePagamento/3";
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(obj),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
