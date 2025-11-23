import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thaurus_cnc/model/cliente/ClienteModel.dart';


class ClienteService {
  //final String baseUrl = 'http://31.97.165.102/api/clientes';
 // final String baseUrl = 'http://192.168.86.7:8080/api/clientes';
  final String baseUrl = 'https://www.thauruscnc.com.br/api/clientes';

  Future<bool> criarCliente(ClienteModel pedido) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pedido.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Cliente criado com sucesso!');
      return true;
    } else {
      print(response.body);
      print('❌ Erro ao criar cliente: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  Future<List<ClienteModel>> listarClientes() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print(data);
      return data.map((e) => ClienteModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar cliente');
    }
  }

  Future<bool> updateCliente(ClienteModel produto) async {
    print(produto);
    final url = Uri.parse('$baseUrl/${produto.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ cliente atualizado com sucesso!');
      return true;
    } else {
      print(response.body);
      print('❌ Erro ao criar cliente: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  Future<bool> deleteClientes(ClienteModel produto) async {
    final url = Uri.parse('$baseUrl/${produto.id}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Erro ao deletar o cliente');
    }
  }

}

