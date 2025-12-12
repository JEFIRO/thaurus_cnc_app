import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

class ProdutoDropdown extends StatefulWidget {
  final Function(ProdutoModel?) onChanged;

  const ProdutoDropdown({super.key, required this.onChanged});

  @override
  State<ProdutoDropdown> createState() => _ProdutoDropdownState();
}

class _ProdutoDropdownState extends State<ProdutoDropdown> {
  ProdutoModel? produtoSelecionado;
  List<ProdutoModel> produtos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    try {
      final lista = await ProdutoService().listarProdutos();
      setState(() {
        produtos = lista;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return DropdownButtonFormField<ProdutoModel>(
      value: produtoSelecionado,
      dropdownColor: const Color(0xFF2B2B2B),
      items: produtos.map((produto) {
        return DropdownMenuItem<ProdutoModel>(
          value: produto,
          child: Text(
            produto.nome ?? 'Sem nome',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (novoProduto) {
        setState(() => produtoSelecionado = novoProduto);
        widget.onChanged(novoProduto);
      },
      decoration: InputDecoration(
        labelText: "Selecione o produto",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
    );
  }
}
