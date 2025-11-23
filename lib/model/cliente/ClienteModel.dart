import '';
import 'Endereco.dart';

class ClienteModel {
  int? id;
  String? nome;
  String? telefone;
  String? email;
  String? cpf;
  Endereco? endereco;
  DateTime? dataCadastro;
  bool? ativo;

  ClienteModel({
    this.id,
    this.nome,
    this.telefone,
    this.email,
    this.cpf,
    this.endereco,
    this.dataCadastro,
    this.ativo,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      cpf: json['cpf'],
      endereco: json['endereco'] != null
          ? Endereco.fromJson(json['endereco'])
          : null,
      dataCadastro: json['data_cadastro'] != null
          ? DateTime.parse(json['data_cadastro'])
          : null,
      ativo: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpf': cpf,
      'endereco': endereco?.toJson(),
      'data_cadastro': dataCadastro?.toIso8601String(),
      'ativo': ativo,
    };
  }
}
