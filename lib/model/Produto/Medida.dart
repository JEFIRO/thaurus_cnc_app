class Medida {
  int altura;
  int largura;
  int profundidade;
  double peso; // agora é double

  Medida({
    required this.altura,
    required this.largura,
    required this.profundidade,
    required this.peso,
  });

  factory Medida.fromJson(Map<String, dynamic> json) {
    return Medida(
      altura: json['altura'] ?? 0,
      largura: json['largura'] ?? 0,
      profundidade: json['profundidade'] ?? 0,
      peso: (json['peso'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'altura': altura,
    'largura': largura,
    'profundidade': profundidade,
    'peso': peso,
  };
}
