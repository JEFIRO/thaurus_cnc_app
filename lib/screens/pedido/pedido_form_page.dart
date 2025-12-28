import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/routes.dart';
import 'package:thaurus_cnc/service/cliente_service.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

import '../../model/item_request.dart';
import '../../model/pedido/pedido_item_model.dart';
import '../../widgets/pedido_form_card.dart';
import '../../widgets/search_filter_sort_app_bar.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cliente.nome ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              if (cliente.email != null)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    cliente.email!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ),
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
              'Adicionar novo cliente',
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os itens')));
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
      appBar: AppBar(title: const Text("Novo Pedido")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _abrirModal();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add produto', style: TextStyle(color: Colors.white)),
        elevation: 20,
        highlightElevation: 20,
        backgroundColor: Colors.black,
      ),

      backgroundColor: const Color(0xFF0C3F57),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        const Text(
                          'Detalhes do pedido',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 15),
                        Card(
                          color: Color(0xFF0C3F57),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Cliente",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<ClienteModel>(
                                        value: _clienteSelecionado,
                                        isExpanded: true,
                                        dropdownColor: const Color(0xFF163A4A),
                                        iconEnabledColor: Colors.white,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        hint: const Text(
                                          'Selecione o cliente',
                                          style: TextStyle(
                                            color: Colors.white38,
                                          ),
                                        ),
                                        items: items,
                                        onChanged: (ClienteModel? value) {
                                          if (value == null) return;

                                          if (value.id == -1) {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.clientFormPage,
                                            );
                                            return;
                                          }

                                          setState(() {
                                            _clienteSelecionado = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Card(
                                        color: const Color(0xFF0C3F57),
                                        elevation: 10,
                                        shadowColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Frete",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                              ),

                                              const SizedBox(height: 16),

                                              const Text(
                                                "CEP",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              TextField(
                                                maxLength: 8,
                                                controller: _cepController,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration: InputDecoration(
                                                  counterText: '',

                                                  hintText: '00000000',
                                                  hintStyle: const TextStyle(
                                                    color: Colors.white38,
                                                  ),

                                                  filled: true,
                                                  fillColor: const Color(
                                                    0xFF163A4A,
                                                  ),

                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 14,
                                                      ),

                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    borderSide: BorderSide.none,
                                                  ),

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide:
                                                            const BorderSide(
                                                              color: Colors
                                                                  .blueAccent,
                                                              width: 1.5,
                                                            ),
                                                      ),
                                                ),
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
      backgroundColor: const Color(0xFF0C3F57),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final Map<ProdutoModel, int> selecionadosTemp = {};

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Selecionar produtos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Colors.white24),

                  // LISTA DE PRODUTOS
                  Expanded(
                    child: ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (_, index) {
                        final produto = _produtos[index];
                        final quantidade = selecionadosTemp[produto] ?? 0;
                        final selecionado = quantidade > 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: selecionado
                              ? const Color(0xFF163A4A)
                              : const Color(0xFF102E3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: selecionado
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    produto.imagem,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produto.nome,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        produto.descricao,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          _badge(
                                            '${produto.variantes.length} variantes',
                                          ),
                                          if (produto.personalizacao.isNotEmpty)
                                            _badge('Personalizável'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                SizedBox(
                                  width: 48,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        color: Colors.white,
                                        padding: EdgeInsets.zero,
                                        constraints:
                                        const BoxConstraints(),
                                        onPressed: () {
                                          setModalState(() {
                                            selecionadosTemp[produto] =
                                                quantidade + 1;
                                          });
                                        },
                                      ),
                                      Text(
                                        '$quantidade',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        color: Colors.white70,
                                        padding: EdgeInsets.zero,
                                        constraints:
                                        const BoxConstraints(),
                                        onPressed: quantidade > 0
                                            ? () {
                                          setModalState(() {
                                            selecionadosTemp[produto] =
                                                quantidade - 1;
                                          });
                                        }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(color: Colors.white24),

                  // FOOTER
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: const BorderSide(color: Colors.white38),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
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
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
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

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0C3F57),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
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
