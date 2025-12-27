import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thaurus_cnc/model/frete/calcula_frete.dart';

import '../model/Produto/produto_model.dart';
import '../service/frete_service.dart';

class PedidoFreteCard extends StatefulWidget {
  List<ProdutoModel> produtoSelecionado = [];


  PedidoFreteCard({super.key, required this.produtoSelecionado});

  @override
  State<PedidoFreteCard> createState() => _PedidoFreteCardState();
}

class _PedidoFreteCardState extends State<PedidoFreteCard> {
  late TextEditingController _cepController;

  @override
  void initState() {
    super.initState();
    _cepController = TextEditingController();
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0C3F57),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frete",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  "CEP do Cliente:",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    style: const TextStyle(color: Colors.black),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: "00000-000",
                      filled: true,
                      fillColor: Colors.white,
                      counterText: "",
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _cepController,
              builder: (_, value, __) {
                final cepValido = value.text.length == 8;
                final podeCalcular =
                    widget.produtoSelecionado.isNotEmpty && cepValido;
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: podeCalcular ? () {} : null,
                        child: const Text(
                          "Calcular frete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
