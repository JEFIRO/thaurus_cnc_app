class Endereco {
  String? cep;
  String? logradouro;
  String? complemento;
  String? numero;
  String? bairro;
  String? cidade;
  String? uf;
  String? ddd;

  Endereco({
    this.cep,
    this.logradouro,
    this.complemento,
    this.numero,
    this.bairro,
    this.cidade,
    this.uf,
    this.ddd,
  });

  // 🔹 Construtor a partir de JSON
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      uf: json['uf'],
      ddd: json['ddd'],
    );
  }

  // 🔹 Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'ddd': ddd,
    };
  }
}
