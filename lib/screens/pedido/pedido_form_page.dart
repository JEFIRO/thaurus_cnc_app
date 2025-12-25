import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/model/cliente/cliente_model.dart';
import 'package:thaurus_cnc/routes.dart';
import 'package:thaurus_cnc/service/cliente_service.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

class PedidoFormPage extends StatefulWidget {
  PedidoFormPage({super.key});

  @override
  State<PedidoFormPage> createState() => _PedidoFormPageState();
}

class _PedidoFormPageState extends State<PedidoFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<ClienteModel> _clientes = [];
  ClienteModel? _clienteSelecionado;

  List<ProdutoModel> _produtos = [];
  ProdutoModel? _produtoSelecionado;

  Future<List<ClienteModel>> _buscarClientes() async {
    return await ClienteService().listarClientes();
  }

  Future<List<ProdutoModel>> _buscarProduto() async {
    return await ProdutoService().listarProdutos();
  }

  final ProdutoModel _addProdutoItem = ProdutoModel(
    id: -1,
    nome: 'Adicionar novo produto',
    descricao: '',
    imagem: '',
    ativo: true,
    variantes: [],
    personalizacao: {},
  );

  final ClienteModel _addClienteItem = ClienteModel(id: -1);

  @override
  void initState() {
    super.initState();
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

  List<DropdownMenuItem<ProdutoModel>> get itens {
    final lista = _produtos.map((produto) {
      return DropdownMenuItem<ProdutoModel>(
        value: produto,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: produto.imagem != null
                  ? NetworkImage(produto.imagem!)
                  : null,
              child: produto.imagem == null
                  ? Text(produto.nome[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(produto.nome, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      );
    }).toList();

    lista.add(
      DropdownMenuItem<ProdutoModel>(
        value: _addProdutoItem,
        child: Row(
          children: const [
            Icon(Icons.add, color: Colors.green),
            SizedBox(width: 10),
            Text(
              'Adicionar novo produto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C3F57),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8.0),
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
              Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: DropdownButton<ProdutoModel>(
                                hint: const Text('Selecione o Produto'),
                                isExpanded: true,
                                value: _produtoSelecionado,

                                items: itens,
                                onChanged: (ProdutoModel? value) {
                                  if (value == null) return;

                                  if (value.id == -1) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.productFormPage,
                                    );
                                  }
                                  setState(() {
                                    _produtoSelecionado = value;
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
