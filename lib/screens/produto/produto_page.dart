import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:thaurus_cnc/widgets/product_card.dart';
import 'package:thaurus_cnc/screens/produto/produto_detalhe_page.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/screens/produto/produto_form_page.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({super.key});

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  List<ProdutoModel> produtos = [];

  @override
  void initState() {
    super.initState();
    buscarProdutos();
  }

  Future<void> buscarProdutos() async {
    var dados = await ProdutoService().listarProdutos();
    setState(() {
      produtos = dados;
    });
  }

  Future<void> _navegarParaFormulario(
    ProdutoModel produto, {
    bool update = false,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProdutoFormPage(produtoModel: produto, update: update),
      ),
    );

    await buscarProdutos();
  }

  Future<void> _excluirProduto(ProdutoModel produto) async {
    final sucesso = await ProdutoService().deleteProdutos(produto);
    if (sucesso) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${produto.nome} removido')));
      await buscarProdutos();
    }
  }

  int _numVariante(ProdutoModel produto) {
    return produto.variantes.length;
  }

  Widget _buildProdutoImagem(String? img) {
    if (img == null || img.isEmpty) {
      return const Icon(Icons.image_not_supported, color: Colors.white54);
    }

    final trimmedImg = img.trim();

    if (trimmedImg.startsWith('http') || trimmedImg.startsWith('https')) {
      return Image.network(trimmedImg, fit: BoxFit.cover);
    } else {
      try {
        final bytes = base64Decode(trimmedImg);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (e) {
        return const Icon(Icons.broken_image, color: Colors.white54);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Produtos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdutoFormPage(update: false),
            ),
          );
          if (resultado == true) await buscarProdutos();
        },
        child: const Icon(Icons.add),
      ),
      body: produtos.isEmpty
          ? const Center(child: Text("Nenhum produto cadastrado"))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Slidable(
                  key: ValueKey(produto.id ?? produto.nome),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) =>
                            _navegarParaFormulario(produto, update: true),
                        icon: Icons.update,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        label: "Atualizar",
                      ),
                      SlidableAction(
                        onPressed: (context) =>
                            _navegarParaFormulario(produto, update: false),
                        icon: Icons.control_point_duplicate,
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        label: "Duplicar",
                      ),
                      SlidableAction(
                        onPressed: (context) => _excluirProduto(produto),
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        label: "Excluir",
                      ),
                    ],
                  ),
                  child: ProductCard(
                    nome: produto.nome,
                    imageUrl: produto.imagem.trim(),
                    descricao: produto.descricao,
                    variacoes: _numVariante(produto),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProdutoDetalhePage(produto: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
