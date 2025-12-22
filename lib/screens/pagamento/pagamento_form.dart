import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:thaurus_cnc/model/pagamentos/metodo_pagamento.dart';
import 'package:thaurus_cnc/service/payment_service.dart';

class PagamentoForm extends StatefulWidget {
  final int idPedido;

  const PagamentoForm({super.key, required this.idPedido});

  @override
  State<PagamentoForm> createState() => _PagamentoFormState();
}

class _PagamentoFormState extends State<PagamentoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _obsController = TextEditingController();
  MetodoPagamento? _valorSelecionado;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> salvarPagamento() async {
    if (_formKey.currentState!.validate() && _valorSelecionado != null) {
      double valor = double.parse(
        _nomeController.text
            .replaceAll('R\$', '')
            .replaceAll(' ', '')
            .replaceAll(',', '.'),
      );

      final dados = {
        'valorPago': valor,
        'metodoPagamento':"${_valorSelecionado!.name}",
        'observacao': _obsController.text,
      };
      try {
        final pagamento = await PaymentService().pagarPedido(
          widget.idPedido,
          dados,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pagamento realizado com sucesso')),
        );

        Navigator.pop(context, pagamento);

        print(dados);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao realizar pagamento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C3F57),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Detalhes do pagamento',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DropdownButton<MetodoPagamento>(
                                hint: const Text('Selecione o método'),
                                isExpanded: true,
                                value: _valorSelecionado,
                                items: const [
                                  DropdownMenuItem(
                                    value: MetodoPagamento.PIX,
                                    child: Text('PIX'),
                                  ),
                                  DropdownMenuItem(
                                    value: MetodoPagamento.CREDIT_CARD,
                                    child: Text('Cartão'),
                                  ),
                                  DropdownMenuItem(
                                    value: MetodoPagamento.DEBIT_CARD,
                                    child: Text('Debito'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _valorSelecionado = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(Icons.attach_money),
                            SizedBox(width: 8),
                            Text(
                              "Valor pago",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        TextFormField(
                          controller: _nomeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MoneyInputFormatter(
                              leadingSymbol: 'R\$ ',
                              thousandSeparator: ThousandSeparator.Period,
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Valor pago',
                            filled: true,
                            fillColor: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe o valor';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        TextFormField(
                          controller: _obsController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Observação (opcional)',
                            filled: true,
                            fillColor: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            salvarPagamento();
                          },
                          child: Text(
                            "Confirmar Pagamento",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
