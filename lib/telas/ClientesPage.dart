import 'package:flutter/material.dart';
import 'package:thaurus_cnc/model/cliente/ClienteModel.dart';
import '../service/ClienteService.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<ClienteModel> itens = [];
  List<ClienteModel> itensFiltrados = [];

  String busca = '';
  String filtroSelecionado = 'Todos';
  String ordenacaoSelecionada = 'Padrão';

  final List<String> filtros = ['Todos', 'Com email', 'Sem email'];
  final List<String> ordenacoes = [
    'Padrão',
    'Nome (A-Z)',
    'Nome (Z-A)',
    'Com telefone',
    'Sem telefone',
  ];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final dados = await ClienteService().listarClientes();
    setState(() {
      itens = dados;
      aplicarFiltros();
    });
  }

  void aplicarFiltros() {
    List<ClienteModel> lista = itens.where(filtrar).toList();
    ordenar(lista);
    setState(() => itensFiltrados = lista);
  }

  bool filtrar(ClienteModel c) {
    final nome = (c.nome ?? '').toLowerCase();
    final email = (c.email ?? '').trim();

    bool matchBusca = nome.contains(busca.toLowerCase());
    bool matchFiltro = true;

    if (filtroSelecionado == 'Com email') {
      matchFiltro = email.isNotEmpty && email != 'nao_fornecido';
    } else if (filtroSelecionado == 'Sem email') {
      matchFiltro = email.isEmpty || email == 'nao_fornecido';
    }

    return matchBusca && matchFiltro;
  }

  void ordenar(List<ClienteModel> lista) {
    switch (ordenacaoSelecionada) {
      case 'Nome (A-Z)':
        lista.sort((a, b) => (a.nome ?? '').compareTo(b.nome ?? ''));
        break;

      case 'Nome (Z-A)':
        lista.sort((a, b) => (b.nome ?? '').compareTo(a.nome ?? ''));
        break;

      case 'Com telefone':
        lista.sort((a, b) {
          final aHas = a.telefone?.trim().isNotEmpty ?? false;
          final bHas = b.telefone?.trim().isNotEmpty ?? false;
          return bHas.toString().compareTo(aHas.toString());
        });
        break;

      case 'Sem telefone':
        lista.sort((a, b) {
          final aNot = !(a.telefone?.trim().isNotEmpty ?? false);
          final bNot = !(b.telefone?.trim().isNotEmpty ?? false);
          return bNot.toString().compareTo(aNot.toString());
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Clientes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => abrirFiltros(context),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar cliente...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2B2B2B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
              onChanged: (text) {
                busca = text;
                aplicarFiltros();
              },
            ),
          ),

          Expanded(
            child: itensFiltrados.isEmpty
                ? const Center(
              child: Text(
                "Nenhum item encontrado",
                style: TextStyle(color: Colors.white54),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: itensFiltrados.length,
              itemBuilder: (context, index) =>
                  buildItem(itensFiltrados[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(ClienteModel cliente) {
    return Card(
      color: const Color(0xFF2B2B2B),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => mostrarDetalhes(cliente),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cliente.nome ?? 'Nome não informado',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                    cliente.telefone?.trim().isNotEmpty == true
                        ? cliente.telefone!
                        : 'Sem telefone',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                    cliente.email?.trim().isNotEmpty == true
                        ? cliente.email!
                        : 'Sem email',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mostrarDetalhes(ClienteModel cliente) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: Text(
          cliente.nome ?? 'Cliente',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Telefone: ${cliente.telefone?.trim().isNotEmpty == true ? cliente.telefone : '-'}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'Email: ${cliente.email?.trim().isNotEmpty == true ? cliente.email : '-'}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              'CPF: ${cliente.cpf ?? '-'}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Fechar',
                style: TextStyle(color: Colors.greenAccent)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void abrirFiltros(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF212121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: ListView(
                controller: controller,
                children: [
                  const Text(
                    "Filtros e Ordenação",
                    style: TextStyle(
                      color: Color(0xFFFAFAFA),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Filtrar por",
                    style: TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  ...filtros.map(
                        (f) => filtroItem(
                      title: f,
                      groupValue: filtroSelecionado,
                      onSelect: (v) {
                        setState(() => filtroSelecionado = v);
                        aplicarFiltros();
                      },
                    ),
                  ),

                  divider(),

                  const Text(
                    "Ordenar por",
                    style: TextStyle(
                      color: Color(0xFFD7CCC8),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  ...ordenacoes.map(
                        (o) => filtroItem(
                      title: o,
                      groupValue: ordenacaoSelecionada,
                      onSelect: (v) {
                        setState(() => ordenacaoSelecionada = v);
                        aplicarFiltros();
                      },
                    ),
                  ),

                  const SizedBox(height: 26),

                  // BOTÃO APLICAR
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC2185B),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Aplicar",
                          style: TextStyle(
                            color: Color(0xFFFAFAFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget filtroItem({
    required String title,
    required String groupValue,
    required Function(String) onSelect,
  }) {
    return InkWell(
      onTap: () => onSelect(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFAFAFA),
                fontSize: 16,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: title == groupValue
                      ? const Color(0xFFC2185B)
                      : const Color(0xFFB0BEC5),
                  width: 2,
                ),
              ),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: title == groupValue
                      ? const Color(0xFFC2185B)
                      : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.white12,
      thickness: 1,
      height: 26,
    );
  }
}
