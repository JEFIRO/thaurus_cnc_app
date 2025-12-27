import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/routes.dart';
import 'package:thaurus_cnc/service/cliente_service.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

import '../../model/item_request.dart';
import '../../model/pedido/pedido_item_model.dart';
import '../../widgets/pedido_form_card.dart';
import '../frete/frete_option.dart';

class PedidoFormPage extends StatefulWidget {
  PedidoFormPage({super.key});

  @override
  State<PedidoFormPage> createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cepController;

  List<ItemRequest> listItemRequest = [];

  List<ClienteModel> _clientes = [];

  ClienteModel? _clienteSelecionado;

  List<ProdutoModel> _produtos = [];

  List<PedidoItemModel> _pedidosSelecionados = [];

  List<PedidoItemDraft> _itensSelecionados = [];

  Future<List<ClienteModel>> _buscarClientes() async {
    return await ClienteService().listarClientes();
  }

  Future<List<ProdutoModel>> _buscarProduto() async {
    return await ProdutoService().listarProdutos();
  }

  final ClienteModel _addClienteItem = ClienteModel(id: -1);

  @override
  void initState() {
    super.initState();
    _cepController = TextEditingController();
    _carregarClientes();
    _buscarProduto();
  }

  void _carregarClientes() async {
    final clientes = await _buscarClientes();
    final produtos = await _buscarProduto();
    setState(() {
      _clientes = clientes;
      _produtos = produtos;
    });
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<ClienteModel>> get items {
    final list = _clientes.map((cliente) {
      return DropdownMenuItem<ClienteModel>(
        value: cliente,
        child: Text(cliente.nome!),
      );
    }).toList();

    list.add(
      DropdownMenuItem<ClienteModel>(
        value: _addClienteItem,
        child: Row(
          children: const [
            Icon(Icons.add, color: Colors.green),
            SizedBox(width: 10),
            Text(
              'Adicionar novo Cliente',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
    return list;
  }

  bool _validarCep() {
    final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');

    if (cep.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o CEP')));
      return false;
    }

    if (cep.length != 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP deve ter 8 dígitos')));
      return false;
    }
    return true;
  }

  bool _validarCliente() {
    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um cliente')));
      return false;
    }
    return true;
  }

  bool _validaItens() {
    if (_itensSelecionados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Escolha os itens')));
      return false;
    }

    if (_itensSelecionados.any((e) => e.item == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os itens')));
      return false;
    }

    return true;
  }

  void _carregarTelaDeFrete() {
    if (!_validarCep() || !_validarCliente()) return;

    for (final draft in _itensSelecionados) {
      draft.key.currentState?.buildItemAndReturn();
    }

    if (_itensSelecionados.any((e) => e.item == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os itens')),
      );
      return;
    }

    final itens = _itensSelecionados.map((e) => e.item!).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FreteOption(
          listItemRequest: itens,
          cliente: _clienteSelecionado!,
          cep: _cepController.text,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C3F57),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Detalhes do pagamento',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: DropdownButton<ClienteModel>(
                                hint: const Text('Selecione o cliente'),
                                isExpanded: true,
                                value: _clienteSelecionado,
                                items: items,
                                onChanged: (ClienteModel? value) {
                                  if (value == null) return;
                                  if (value.id == -1) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.clientFormPage,
                                    );
                                  }
                                  setState(() {
                                    _clienteSelecionado = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: _abrirModal,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Produtos',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _pedidosSelecionados.isEmpty
                                  ? 'Selecione os produtos'
                                  : _pedidosSelecionados
                                        .map((e) => e.nomeProduto)
                                        .join(', '),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _itensSelecionados == null ||
                                _itensSelecionados!.isEmpty
                            ? Container(
                                child: Text("Nenhum Produto Selecionado"),
                              )
                            : Column(
                                children: _itensSelecionados.map((draft) {
                                  return PedidoFormCard(
                                    key: draft.key,
                                    produto: draft.produto,
                                    onBuild: (item) {
                                      setState(() {
                                        draft.item = item;
                                      });
                                    },
                                    onRemove: () {
                                      setState(() {
                                        _itensSelecionados.remove(draft);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),

                        ?_itensSelecionados.isEmpty
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(16),
                                      child: Card(
                                        color: Color(0xFF0C3F57),
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Frete",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  const Text(
                                                    "Cep: ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          _cepController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                            hintText:
                                                                '00000-000',
                                                            isDense: true,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ?_itensSelecionados.isEmpty
                            ? null
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _carregarTelaDeFrete();
                                        },
                                        child: Text(
                                          "Continuar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

  void _abrirModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final Map<ProdutoModel, int> selecionadosTemp = {};

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Selecionar produtos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (_, index) {
                        final produto = _produtos[index];
                        final quantidade = selecionadosTemp[produto] ?? 0;

                        return ListTile(
                          title: Text(produto.nome),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: quantidade > 0
                                    ? () {
                                        setModalState(() {
                                          selecionadosTemp[produto] =
                                              quantidade - 1;
                                        });
                                      }
                                    : null,
                              ),
                              Text(
                                '$quantidade',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setModalState(() {
                                    selecionadosTemp[produto] = quantidade + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selecionadosTemp.forEach((produto, qtd) {
                                  for (int i = 0; i < qtd; i++) {
                                    _itensSelecionados.add(
                                      PedidoItemDraft(produto: produto),
                                    );
                                  }
                                });
                              });

                              Navigator.pop(context);
                            },
                            child: const Text('Confirmar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class PedidoItemDraft {
  final String uid = UniqueKey().toString();
  final ProdutoModel produto;
  final GlobalKey<PedidoFormCardState> key = GlobalKey<PedidoFormCardState>();

  ItemRequest? item;

  PedidoItemDraft({required this.produto});
}
