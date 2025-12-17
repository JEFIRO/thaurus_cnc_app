import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormularioDialog extends StatefulWidget {
  @override
  State<FormularioDialog> createState() => _FormularioDialogState();
}

class _FormularioDialogState extends State<FormularioDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Novo Pagamento",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Descrição"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obrigatório" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Valor"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o valor" : null,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ação
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
