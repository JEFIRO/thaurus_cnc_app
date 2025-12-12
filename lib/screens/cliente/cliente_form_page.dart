import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/model/cliente/endereco_model.dart';
import 'package:thaurus_cnc/service/cliente_service.dart';

class ClienteFormPage extends StatefulWidget {
  const ClienteFormPage({super.key});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  final telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####');
  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final cepMask = MaskTextInputFormatter(mask: '#####-###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Cliente"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(_nomeController, "Nome", Icons.person),
                  _buildTextField(
                    _telefoneController,
                    "Telefone",
                    Icons.phone,
                    inputFormatters: [telefoneMask],
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    _emailController,
                    "Email",
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    _cpfController,
                    "CPF",
                    Icons.badge,
                    inputFormatters: [cpfMask],
                    keyboardType: TextInputType.number,
                  ),
                  const Divider(),
                  _buildTextField(
                    _cepController,
                    "CEP",
                    Icons.location_on,
                    inputFormatters: [cepMask],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _numeroController,
                    "Número",
                    Icons.home,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _complementoController,
                    "Complemento",
                    Icons.add_location_alt,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      var cliente = ClienteModel(
                        id: null,
                        nome: _nomeController.text,
                        telefone: _telefoneController.text,
                        email: _emailController.text,
                        cpf: _cepController.text,
                        endereco: EnderecoModel(
                          cep: _cepController.text,
                          numero: _numeroController.text,
                          complemento: _complementoController.text,
                        ),
                      );
                      var b = ClienteService().criarCliente(cliente);
                      if (await b) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cliente Cadastrado")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erro ao criar o cliente.")),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obrigatório' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
