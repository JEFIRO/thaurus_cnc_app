import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagemPicker extends StatefulWidget {
  const ImagemPicker({super.key});

  @override
  State<ImagemPicker> createState() => _ImagemPickerState();
}

class _ImagemPickerState extends State<ImagemPicker> {
  String? _caminhoArquivo;

  Future<String?> _selecionarImagem() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final caminho = result.files.single.path!;
      setState(() {
        _caminhoArquivo = caminho;
        debugPrint(_caminhoArquivo);
        print(_caminhoArquivo);
      });
      return caminho;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _selecionarImagem,
          child: Text("Selecionar imagem"),
        ),
        if (_caminhoArquivo != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              File(_caminhoArquivo!),
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}
