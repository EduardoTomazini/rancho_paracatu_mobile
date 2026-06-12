import 'dart:convert';
import 'package:http/http.dart' as http;

class CardapioService {
  final String apiUrl = 'https://gist.githubusercontent.com/EduardoTomazini/7e9cce505a662e3998bd5ff283452c37/raw';

  Future<List<Map<String, dynamic>>> fetchProdutos() async {
    // Faz a requisição HTTP real (Cumprindo o RF005)
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      // Retorna os dados decodificando o UTF-8 para os acentos aparecerem certos
      return List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Falha ao carregar o cardápio da API');
    }
  }
}