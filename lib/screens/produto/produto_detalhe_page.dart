import 'package:flutter/material.dart';
import 'package:thaurus_cnc/app_theme.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';

class ProdutoDetalhePage extends StatelessWidget {
  final ProdutoModel produto;

  const ProdutoDetalhePage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha Técnica')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  produto.imagem,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 250,
                    height: 250,
                    color: AppTheme.grafiteProfundo,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppTheme.cinzaMedio,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              produto.nome,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                color: AppTheme.branco,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              produto.ativo ? 'Status: Ativo' : 'Status: Inativo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: produto.ativo ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            Text(
              'Descrição',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: AppTheme.branco,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              produto.descricao,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.cinzaClaro),
            ),
            const SizedBox(height: 16),

            // Personalizações em Grid
            if (produto.personalizacao.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalizações',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: AppTheme.branco,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3,
                        ),
                    itemCount: produto.personalizacao.length,
                    itemBuilder: (_, index) {
                      final entry = produto.personalizacao.entries.elementAt(
                        index,
                      );
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cinzaEscuro,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(color: AppTheme.cinzaClaro),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            if (produto.variantes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Variantes (${produto.variantes.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: AppTheme.branco,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...produto.variantes.map(
                    (v) => ExpansionTile(
                      collapsedBackgroundColor: AppTheme.cinzaEscuro,
                      backgroundColor: AppTheme.cinzaEscuro,
                      collapsedIconColor: AppTheme.branco,
                      iconColor: AppTheme.branco,
                      title: Text(
                        'Valor: ${v.valor}',
                        style: TextStyle(color: AppTheme.branco),
                      ),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      children: [
                        Text(
                          'Medidas do Produto: ${v.medidaProduto.altura} x ${v.medidaProduto.largura} x ${v.medidaProduto.profundidade} cm, Peso: ${v.medidaProduto.peso} kg',
                          style: TextStyle(color: AppTheme.cinzaClaro),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Medidas da Embalagem: ${v.medidaEmbalagem.altura} x ${v.medidaEmbalagem.largura} x ${v.medidaEmbalagem.profundidade} cm, Peso: ${v.medidaEmbalagem.peso} kg',
                          style: TextStyle(color: AppTheme.cinzaClaro),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
