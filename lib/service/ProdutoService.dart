import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/Produto/ProdutoModel.dart';




class ProdutoService {
  final String baseUrl = 'http://31.97.165.102/api';
  //final String baseUrl = 'http://192.168.86.7:8080/api';

  Future<http.Response> criarProduto(ProdutoModel produto) async {
    final url = Uri.parse('$baseUrl/produtos');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Produto criado com sucesso!');
    } else {
      print('❌ Erro ao criar produto: ${response.statusCode}');
      print(response.body);
    }

    return response;
  }

  Future<List<ProdutoModel>> listarProdutos() async {
    final url = Uri.parse('$baseUrl/produtos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print(data);
      return data.map((e) => ProdutoModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }

  Future<http.Response> updateProduto(ProdutoModel produto) async {
    print(produto);
    final url = Uri.parse('$baseUrl/produtos/${produto.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      print(response.body);
      print('❌ Erro ao criar produto: ${response.statusCode}');
      print(response.body);
      return response;
    }
  }

  Future<bool> deleteProdutos(ProdutoModel produto) async {
    final url = Uri.parse('$baseUrl/produtos/${produto.id}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Erro ao deletar o produto');
    }
  }

}
