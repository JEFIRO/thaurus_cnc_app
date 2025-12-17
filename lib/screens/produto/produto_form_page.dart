import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:thaurus_cnc/app_theme.dart';
import 'package:thaurus_cnc/model/Produto/medida_model.dart';
import 'package:thaurus_cnc/model/Produto/produto_model.dart';
import 'package:thaurus_cnc/model/Produto/variante.dart';
import 'package:thaurus_cnc/service/drive_service.dart';
import 'package:thaurus_cnc/service/produto_service.dart';

class ProdutoFormPage extends StatefulWidget {
  final ProdutoModel? produtoModel;
  final bool update;

  const ProdutoFormPage({super.key, this.produtoModel, this.update = false});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  final _idController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imgController = TextEditingController();

  List<Map<String, TextEditingController>> personalizacoes = [];
  List<VarianteForm> variantesForm = [];
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.produtoModel != null) {
      _nomeController.text = widget.produtoModel!.nome;
      _descricaoController.text = widget.produtoModel!.descricao;
      _imgController.text = widget.produtoModel!.imagem;
      _idController.text = widget.produtoModel!.id?.toString() ?? '';
      personalizacoes = widget.produtoModel!.personalizacao.entries
          .map(
            (e) => {
              "chave": TextEditingController(text: e.key),
              "valor": TextEditingController(text: e.value),
            },
          )
          .toList();

      variantesForm = widget.produtoModel!.variantes.map((v) {
        return VarianteForm(
          valorController: TextEditingController(text: v.valor.toString()),
          medidaProduto: MedidaControllers.fromMedida(v.medidaProduto),
          medidaEmbalagem: MedidaControllers.fromMedida(v.medidaEmbalagem),
        );
      }).toList();
    } else {
      personalizacoes = [
        {"chave": TextEditingController(), "valor": TextEditingController()},
      ];
      variantesForm = [
        VarianteForm(
          valorController: TextEditingController(),
          medidaProduto: MedidaControllers(),
          medidaEmbalagem: MedidaControllers(),
        ),
      ];
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppTheme.cinzaEscuro.withOpacity(0.7),
    labelStyle: const TextStyle(color: AppTheme.cinzaClaro),
    hintStyle: const TextStyle(color: AppTheme.cinzaMedio),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.cinzaMedio, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.branco, width: 2.0),
    ),
  );

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.branco.withOpacity(0.8), size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.branco,
              fontWeight: FontWeight.w700, // Mais negrito
              fontSize: 20, // Tamanho maior
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- Função para escolher a imagem (mantida) ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImageFile = File(pickedFile.path);
        _imgController.text = path.basename(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grafiteProfundo,
      appBar: AppBar(
        title: Text(widget.update ? "Editar Produto" : "Novo Produto"),
        backgroundColor: AppTheme.grafiteProfundo, // Consistência no AppBar
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20), // Padding maior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration("Nome do Produto"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: _inputDecoration("Descrição"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),

              // Campo de Imagem com pré-visualização aprimorada
              TextFormField(
                controller: _imgController,
                readOnly: true,
                style: const TextStyle(color: AppTheme.cinzaClaro),
                decoration: _inputDecoration("Imagem").copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.image, color: AppTheme.cinzaClaro),
                    onPressed: _pickImage,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              if (_pickedImageFile != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.grafiteProfundo.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _pickedImageFile!,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 30),

              // Seção de Personalizações
              _buildSectionTitle("Personalizações", Icons.settings_suggest),
              ..._buildPersonalizacoes(),

              const SizedBox(height: 30),

              // Seção de Variantes
              _buildSectionTitle("Variantes", Icons.inventory_2),
              ..._buildVariantes(),

              const SizedBox(height: 40),

              // Botão Principal
              ElevatedButton(
                onPressed: _handleSaveOrUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.branco,
                  foregroundColor: AppTheme.grafiteProfundo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  widget.update ? "ATUALIZAR PRODUTO" : "SALVAR PRODUTO",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSaveOrUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ProdutoService();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processando..."),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      String? publicUrl;
      if (_pickedImageFile != null) {
        File imageFile = File(_pickedImageFile!.path);

        publicUrl = await DriveService().enviaImagem(imageFile);
      }

      final produto = ProdutoModel(
        id: int.tryParse(_idController.text),
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        imagem: publicUrl ?? _imgController.text,
        personalizacao: {
          for (var p in personalizacoes)
            if (p["chave"]!.text.isNotEmpty) p["chave"]!.text: p["valor"]!.text,
        },
        variantes: variantesForm.map((v) {
          return Variante(
            valor: double.tryParse(v.valorController.text) ?? 0,
            medidaProduto: MedidaModel(
              largura: int.tryParse(v.medidaProduto.largura.text) ?? 0,
              altura: int.tryParse(v.medidaProduto.altura.text) ?? 0,
              profundidade:
                  int.tryParse(v.medidaProduto.profundidade.text) ?? 0,
              peso: double.tryParse(v.medidaProduto.peso.text) ?? 0.0,
            ),
            medidaEmbalagem: MedidaModel(
              largura: int.tryParse(v.medidaEmbalagem.largura.text) ?? 0,
              altura: int.tryParse(v.medidaEmbalagem.altura.text) ?? 0,
              profundidade:
                  int.tryParse(v.medidaEmbalagem.profundidade.text) ?? 0,
              peso: double.tryParse(v.medidaEmbalagem.peso.text) ?? 0.0,
            ),
          );
        }).toList(),
        ativo: true,
      );

      final response = widget.update
          ? await service.updateProduto(produto)
          : await service.criarProduto(produto);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.update
                  ? "Produto atualizado com sucesso!"
                  : "Produto criado com sucesso!",
            ),
            backgroundColor: Colors.green, // Destaque para sucesso
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar produto: ${response.statusCode}"),
            backgroundColor: Colors.red, // Destaque para erro
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro inesperado: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- Widgets de Personalização (Melhorados) ---
  List<Widget> _buildPersonalizacoes() {
    return [
      ...personalizacoes.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: item["chave"],
                  decoration: _inputDecoration("Chave (Ex: Cor)"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: item["valor"],
                  decoration: _inputDecoration("Valor (Ex: Azul)"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.cinzaClaro,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() => personalizacoes.removeAt(index));
                  },
                ),
              ),
            ],
          ),
        );
      }),
      // Botão com efeito de transição sutil
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        ),
        child: personalizacoes.length < 10
            ? OutlinedButton.icon(
                key: const ValueKey('add_pers'),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text("Adicionar Campo"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.cinzaClaro,
                  side: const BorderSide(color: AppTheme.cinzaMedio, width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    personalizacoes.add({
                      "chave": TextEditingController(),
                      "valor": TextEditingController(),
                    });
                  });
                },
              )
            : Container(key: const ValueKey('max_pers')),
      ),
    ];
  }

  // --- Widgets de Variantes (Aprimorados com Card e Detalhes) ---
  List<Widget> _buildVariantes() {
    return [
      ...variantesForm.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Card(
          color: AppTheme.cinzaEscuro.withOpacity(0.8),
          elevation: 4,
          // Adiciona sombra para profundidade
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordas mais suaves
          ),
          margin: const EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Variante #${index + 1}",
                      style: const TextStyle(
                        color: AppTheme.branco,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.cinzaClaro),
                      onPressed: () {
                        setState(() => variantesForm.removeAt(index));
                      },
                    ),
                  ],
                ),
                const Divider(color: AppTheme.cinzaMedio, height: 20),
                TextFormField(
                  controller: item.valorController,
                  decoration: _inputDecoration("Valor (R\$)"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildMedidaFields("📦 Medidas do Produto", item.medidaProduto),
                const SizedBox(height: 16),
                _buildMedidaFields(
                  "🚚 Medidas da Embalagem",
                  item.medidaEmbalagem,
                ),
              ],
            ),
          ),
        );
      }),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        ),
        child: variantesForm.length < 5
            ? OutlinedButton.icon(
                key: const ValueKey('add_var'),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text("Adicionar Variante"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.cinzaClaro,
                  side: const BorderSide(color: AppTheme.cinzaMedio, width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    variantesForm.add(
                      VarianteForm(
                        valorController: TextEditingController(),
                        medidaProduto: MedidaControllers(),
                        medidaEmbalagem: MedidaControllers(),
                      ),
                    );
                  });
                },
              )
            : Container(key: const ValueKey('max_var')),
      ),
    ];
  }

  // --- Widgets de Medidas (Organizados em Grid) ---
  Widget _buildMedidaFields(String title, MedidaControllers medida) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.cinzaClaro,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        // Grid para as 3 medidas
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            TextFormField(
              controller: medida.largura,
              decoration: _inputDecoration("Largura (cm)"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: medida.altura,
              decoration: _inputDecoration("Altura (cm)"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: medida.profundidade,
              decoration: _inputDecoration("Profundidade (cm)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Campo de Peso em largura total
        TextFormField(
          controller: medida.peso,
          decoration: _inputDecoration("Peso (kg)"),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

// Controladores auxiliares (mantidos)
class VarianteForm {
  final TextEditingController valorController;
  final MedidaControllers medidaProduto;
  final MedidaControllers medidaEmbalagem;

  VarianteForm({
    required this.valorController,
    required this.medidaProduto,
    required this.medidaEmbalagem,
  });
}

class MedidaControllers {
  final largura = TextEditingController();
  final altura = TextEditingController();
  final profundidade = TextEditingController();
  final peso = TextEditingController(); // novo campo

  static MedidaControllers fromMedida(MedidaModel medida) {
    final c = MedidaControllers();
    c.largura.text = medida.largura.toString();
    c.altura.text = medida.altura.toString();
    c.profundidade.text = medida.profundidade.toString();
    c.peso.text = medida.peso.toString();
    return c;
  }
}
