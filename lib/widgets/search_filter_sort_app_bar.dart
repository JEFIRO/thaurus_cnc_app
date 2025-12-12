import 'package:flutter/material.dart';

class SearchFilterSortAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Function(String) onSearchChanged;
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;
  final List<String> filtros;
  final List<String> ordenacoes;
  final String titulo;

  const SearchFilterSortAppBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.filtros,
    required this.ordenacoes,
    this.titulo = 'Pesquisar...',
  });

  @override
  State<SearchFilterSortAppBar> createState() => _SearchFilterSortAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _SearchFilterSortAppBarState extends State<SearchFilterSortAppBar> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';
  String _selectedSort = 'Padrão';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 3,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.titulo,
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filtrar',
          onSelected: (String filtro) {
            setState(() => _selectedFilter = filtro);
            widget.onFilterChanged(filtro);
          },
          itemBuilder: (BuildContext context) {
            return widget.filtros.map((String filtro) {
              return PopupMenuItem<String>(
                value: filtro,
                child: Row(
                  children: [
                    Icon(
                      _selectedFilter == filtro
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedFilter == filtro
                          ? Colors.blue
                          : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(filtro),
                  ],
                ),
              );
            }).toList();
          },
        ),

        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          tooltip: 'Ordenar',
          onSelected: (String ordem) {
            setState(() => _selectedSort = ordem);
            widget.onSortChanged(ordem);
          },
          itemBuilder: (BuildContext context) {
            return widget.ordenacoes.map((String ordem) {
              return PopupMenuItem<String>(
                value: ordem,
                child: Row(
                  children: [
                    Icon(
                      _selectedSort == ordem
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedSort == ordem ? Colors.blue : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(ordem),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
