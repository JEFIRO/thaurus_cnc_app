import 'package:flutter/material.dart';
import 'package:thaurus_cnc/screens/cliente/cliente_form_page.dart';
import 'package:thaurus_cnc/screens/cliente/cliente_page.dart';
import 'package:thaurus_cnc/screens/pedido/pedido_page.dart';
import 'package:thaurus_cnc/screens/produto/produto_form_page.dart';
import 'package:thaurus_cnc/screens/produto/produto_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thaurus CNC")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Cadastrar Produto"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdutoFormPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Lista de Produtos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdutoPage()),
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Lista de Produtos")));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: Text("Lista De Pedidos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PedidoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Cadastrar Cliente"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClienteFormPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Lista de Clientes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Bem-vindo ao Painel!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
