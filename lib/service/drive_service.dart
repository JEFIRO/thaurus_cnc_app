import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class DriveService {

  final String baseUrl = 'https://www.thauruscnc.com.br/api/photo/upload';

  Future<String?> enviaImagem(File pickedImageFile) async {
    final url = Uri.parse(baseUrl);

    var request = http.MultipartRequest('POST', url);

    final fileName = path.basename(pickedImageFile.path);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        pickedImageFile.path,
        filename: fileName,
      ),
    );

    var response = await request.send();

    final respStr = await response.stream.bytesToString();

    final jsonResp = json.decode(respStr);

    print(jsonResp["url"]);


    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Imagem enviada com sucesso!');
      print('Link da imagem: $jsonResp["url"]');
      return jsonResp["url"];
    } else {
      print('❌ Erro ao enviar imagem: ${response.statusCode}');
      print(respStr);
      return null;
    }
  }
}