import 'package:flutter/material.dart';
import 'package:thaurus_cnc/telas/ClientesPage.dart';
import 'package:thaurus_cnc/telas/ProdutoForm.dart';
import 'package:thaurus_cnc/telas/ProdutoView.dart';

import '../model/pedido/PedidoView.dart';
import 'ClienteForm.dart';

class HomeScreen extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => ProdutoForm()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Lista de Produtos"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Produtoview()),
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
                  MaterialPageRoute(builder: (context) => Pedidoview()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Cadastrar Cliente"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClienteForm()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Lista de Clientes"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesPage()),
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
