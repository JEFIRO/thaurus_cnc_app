import 'package:flutter/material.dart';

class Produto extends StatelessWidget {
  const Produto({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome"),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite o nome",
                  ),
                ),
                SizedBox(height: 16),
                Text("Descrição"),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite a descrição",
                  ),
                ),
                SizedBox(height: 16),
                Text("Preço"),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Digite o preço",
                  ),
                ),
                SizedBox(height: 16),
                Text("Imagem"),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "URL da imagem",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
