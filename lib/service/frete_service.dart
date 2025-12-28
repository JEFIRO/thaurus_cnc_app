import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:thaurus_cnc/model/frete/calcula_frete.dart';

class FreteService {
  final String baseUrl = 'https://www.thauruscnc.com.br/api/calcularFrete';

  Future<String?> calulaFrete(String cep, List<CalculaFrete> request) async {
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');

    final url = Uri.parse('$baseUrl/$cepLimpo');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.map((e) => e.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      return response.body;
    } else {
      debugPrint('Erro ao calcular frete: ${response.statusCode}');
      debugPrint(response.body);
      return null;
    }
  }
}
