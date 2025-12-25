import 'package:flutter/material.dart';
import 'package:thaurus_cnc/routes.dart';

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
                Navigator.pushNamed(context, Routes.productFormPage);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Lista de Produtos"),
              onTap: () {
                Navigator.pushNamed(context, Routes.productPage);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Lista de Produtos")));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: Text("Lista De Pedidos"),
              onTap: () {
                Navigator.pushNamed(context, Routes.orderPage);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Cadastrar Pedido"),
              onTap: () {
                Navigator.pushNamed(context, Routes.pedidoFormPage);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Cadastrar Cliente"),
              onTap: () {
                Navigator.pushNamed(context, Routes.clientFormPage);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Lista de Clientes"),
              onTap: () {
                Navigator.pushNamed(context, Routes.clientPage);
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
