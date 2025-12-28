import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/model/Produto/variante.dart';
import 'package:thaurus_cnc/model/item_request.dart';

class PedidoFormCard extends StatefulWidget {
  final ProdutoModel produto;
  final void Function(ItemRequest) onBuild;
  final VoidCallback onRemove;

  const PedidoFormCard({
    super.key,
    required this.produto,
    required this.onBuild,
    required this.onRemove,
  });

  @override
  State<PedidoFormCard> createState() => PedidoFormCardState();
}

class PedidoFormCardState extends State<PedidoFormCard> {
  int _quantidade = 1;

  Map<String, TextEditingController> _controllers = {};

  List<Variante> _variante = [];

  Map<String, dynamic> _personalizacao = {};

  @override
  void initState() {
    super.initState();
    _carregaVariante();
    _personalizacao.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _carregaVariante() {
    setState(() {
      _variante = widget.produto.variantes;
      _personalizacao = widget.produto.personalizacao;
    });
  }

  Variante? _varianteSelecionada;

  List<DropdownMenuItem<Variante>> get items {
    return _variante.map((variante) {
      return DropdownMenuItem<Variante>(
        value: variante,
        child: Text(
          '${variante.medidaProduto.altura}x${variante.medidaProduto.largura}',
        ),
      );
    }).toList();
  }

  void buildItemAndReturn() {
    if (_varianteSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma variante'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final personalizacaoJson = _controllers.map(
      (key, controller) => MapEntry(key, controller.text),
    );

    final item = ItemRequest(
      produto_id: widget.produto.id!,
      variante_id: _varianteSelecionada!.id!,
      personalizacao: personalizacaoJson,
      quantidade: _quantidade,
    );

    widget.onBuild(item);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      color: Color(0xFF0C3F57),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Produto selecionado",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: widget.onRemove,
                        icon: const Icon(
                          Icons.restore_from_trash_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.white24,
                          child: widget.produto.imagem != null
                              ? Image.network(
                                  widget.produto.imagem!,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        widget.produto.nome,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Tamanhos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<Variante>(
                              value: _varianteSelecionada,
                              items: items,
                              onChanged: (Variante? value) {
                                setState(() {
                                  _varianteSelecionada = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Tamanho',
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),

                                filled: true,
                                fillColor: const Color(0xFF163A4A),

                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.blueAccent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              dropdownColor: const Color(0xFF163A4A),
                              iconEnabledColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              hint: const Text(
                                'Selecione o tamanho',
                                style: TextStyle(color: Colors.white38),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  "Personalização",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _personalizacao.entries.map((entry) {
                      _controllers[entry.key] ??= TextEditingController(
                        text: entry.value,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalize(entry.key),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            TextField(
                              controller: _controllers[entry.key],
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Digite ${capitalize(entry.key)}',
                                hintStyle: const TextStyle(
                                  color: Colors.white38,
                                ),

                                filled: true,
                                fillColor: const Color(0xFF163A4A),

                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.blueAccent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Quantidade",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        if (_quantidade > 1) {
                          setState(() {
                            _quantidade--;
                          });
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_quantidade',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _quantidade++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
