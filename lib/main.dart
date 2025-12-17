import 'package:firebase_core/firebase_core.dart';
import 'package:thaurus_cnc/app_theme.dart';
import 'package:thaurus_cnc/routes.dart';
import 'package:thaurus_cnc/screens/cliente/cliente_form_page.dart';
import 'package:thaurus_cnc/screens/cliente/cliente_page.dart';
import 'package:thaurus_cnc/screens/home_page.dart';
import 'package:thaurus_cnc/screens/pedido/pedido_page.dart';
import 'package:thaurus_cnc/screens/produto/produto_form_page.dart';
import 'package:thaurus_cnc/screens/produto/produto_page.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thaurus CNC',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      initialRoute: "/",
      routes: {
        Routes.home: (context) => const HomePage(),
        Routes.productFormPage: (context) => ProdutoFormPage(),
        Routes.productPage: (context) => ProdutoPage(),
        Routes.orderPage: (context) => PedidoPage(),
        Routes.clientFormPage: (context) => ClienteFormPage(),
        Routes.clientPage: (context) => ClientePage(),
      },
    );
  }
}
