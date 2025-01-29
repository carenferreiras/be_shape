import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey = "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";

  Future<String> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return "Mensagem não pode estar vazia.";
    }

    const url = "https://api.openai.com/v1/chat/completions";

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "Você é um assistente de saúde."},
        {"role": "user", "content": message}
      ]
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      print("Status Code: ${response.statusCode}");
      print("Resposta da API: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['choices'] != null &&
            jsonResponse['choices'].isNotEmpty &&
            jsonResponse['choices'][0]['message'] != null) {
          return jsonResponse['choices'][0]['message']['content'];
        } else {
          return "Erro: Resposta inesperada da API.";
        }
      } else if (response.statusCode == 401) {
        return "Erro: Chave de API inválida ou expirada.";
      } else if (response.statusCode == 429) {
        return "Erro: Limite de requisições excedido. Tente novamente mais tarde.";
      } else {
        return "Erro: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      print("Erro ao conectar com o serviço de IA: $e");
      return "Erro ao conectar com o serviço de IA: $e";
    }
  }
}