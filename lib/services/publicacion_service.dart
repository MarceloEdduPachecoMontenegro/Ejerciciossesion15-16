import 'dart0:convert';
import 'package:http/http.dart' as http;
import '../models/publicacion.dart';

class PublicacionService {
  static const String host = 'jsonplaceholder.typicode.com';

  Future<List<Publicacion>> obtenerPublicaciones() async {
    final Uri url = Uri.https(
      host,
      '/posts',
      <String, String>{'_limit': '5'},
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode != 200) {
      throw Exception('Error al consultar el servicio: HTTP ${respuesta.statusCode}');
    }

    // La respuesta raíz es una Lista JSON directa
    final List<dynamic> decodificado =
        jsonDecode(utf8.decode(respuesta.bodyBytes)) as List<dynamic>;

    return decodificado
        .whereType<Map<String, dynamic>>()
        .map(Publicacion.fromJson)
        .toList();
  }
}