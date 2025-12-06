import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thaurus_cnc/model/pedido/PedidoModel.dart';

import '../model/pedido/PedidoListResponse.dart';
import '../model/pedido/PedidoResumoModel.dart';

class Pedidoservice {
  final String baseUrl = 'https://www.thauruscnc.com.br/api';

  Future<bool> criarProduto(PedidoModel pedido) async {
    final url = Uri.parse('$baseUrl/pedidos');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Pedido criado com sucesso!');
      return true;
    } else {
      print(response.body);
      print('❌ Erro ao criar pedido: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  Future<PedidoModel> getPedido(int id) async {
    final url = Uri.parse('$baseUrl/pedidos/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('✅ Pedido ${id} carregado com sucesso!');

      final Map<String, dynamic> data = jsonDecode(response.body);

      print(PedidoModel.fromJson(data).toString());

      return PedidoModel.fromJson(data);
    } else if (response.statusCode == 404) {
      print('❌ Pedido ${id} não encontrado.');
      print(response.body);
      throw Exception('Pedido não encontrado: ${response.statusCode}');
    } else {
      print('❌ Erro ao carregar pedido ${id}: ${response.statusCode}');
      print(response.body);
      // Lança uma exceção em caso de erro no servidor
      throw Exception('Falha ao carregar pedido: ${response.statusCode}');
    }
  }

  Future<List<PedidoResumoModel>> listarPedidos() async {
    final url = Uri.parse('$baseUrl/pedidos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonDecoded = jsonDecode(response.body);

      final responseModel = PedidoListResponse.fromJson(jsonDecoded);

      print(responseModel.content);

      return responseModel.content;
    } else {
      throw Exception(
        'Erro ao carregar pedidos: Status ${response.statusCode}',
      );
    }
  }

  Future<bool> updateProduto(PedidoModel produto) async {
    print(produto);
    final url = Uri.parse('$baseUrl/pedidos/${produto.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Pedido atualizado com sucesso!');
      return true;
    } else {
      print(response.body);
      print('❌ Erro ao criar pedido: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  Future<bool> deleteProdutos(PedidoModel produto) async {
    final url = Uri.parse('$baseUrl/pedido/${produto.id}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Erro ao deletar o produto');
    }
  }
}
