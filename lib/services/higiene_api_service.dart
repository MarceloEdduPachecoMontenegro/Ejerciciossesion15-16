import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/indicador_higiene.dart';

/// Excepción de dominio para gestionar fallos de red y del API.
class ApiException implements Exception {
  final String mensaje;
  const ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Servicio encargado del consumo de endpoints de la OMS.
class HigieneApiService {
  final http.Client _cliente;
  static const String host = 'ghoapi.azureedge.net';
  static const Duration tiempoLimite = Duration(seconds: 12);

  HigieneApiService({http.Client? cliente})
      : _cliente = cliente ?? http.Client();

  /// Endpoint del indicador principal en Perú.
  Uri get urlIndicadores => Uri.https(
        host,
        '/api/WSH_HYGIENE_BASIC',
        <String, String>{r'$filter': "SpatialDim eq 'PER'"},
      );

  /// 1. Obtiene la serie histórica de higiene básica en Perú.
  Future<List<IndicadorHigiene>> obtenerIndicadoresPeru() async {
    try {
      final respuesta =
          await _cliente.get(urlIndicadores).timeout(tiempoLimite);

      if (respuesta.statusCode != 200) {
        throw ApiException(
          'El servicio respondió con el código HTTP ${respuesta.statusCode}. Verifique la disponibilidad.',
        );
      }

      final Map<String, dynamic> decodificado =
          jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;

      final List<dynamic> crudos =
          decodificado['value'] as List<dynamic>? ?? const <dynamic>[];

      final indicadores = crudos
          .whereType<Map<String, dynamic>>()
          .map(IndicadorHigiene.fromJson)
          .toList()
        ..sort((a, b) => a.anio.compareTo(b.anio));

      return indicadores;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('La consulta tardó demasiado. Revisa tu conexión.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor de la OMS.');
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  /// 2. Obtiene el listado de países para un año específico (Ejercicio 4 - Sesión 16).
  Future<List<IndicadorHigiene>> obtenerPaises(int anio) async {
    final Uri urlPaises = Uri.https(
      host,
      '/api/WSH_HYGIENE_BASIC',
      <String, String>{
        r'$filter': "TimeDim eq $anio and SpatialDimType eq 'COUNTRY'",
        r'$top': '20', // Limita a 20 registros para optimizar red
      },
    );

    try {
      final respuesta = await _cliente.get(urlPaises).timeout(tiempoLimite);

      if (respuesta.statusCode != 200) {
        throw ApiException('Código HTTP ${respuesta.statusCode} al consultar países.');
      }

      final Map<String, dynamic> decodificado =
          jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;

      final List<dynamic> crudos =
          decodificado['value'] as List<dynamic>? ?? const <dynamic>[];

      return crudos
          .whereType<Map<String, dynamic>>()
          .map(IndicadorHigiene.fromJson)
          .toList();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('La consulta de países superó el tiempo límite.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor de la OMS.');
    } catch (e) {
      throw ApiException('Error al obtener países: $e');
    }
  }

  /// 3. Obtiene el segundo indicador HWWS_1 para Perú (Ejercicio 5 - Sesión 16).
  Future<List<IndicadorHigiene>> obtenerLavadoManosJabonPeru() async {
    final Uri urlHwws = Uri.https(
      host,
      '/api/HWWS_1',
      <String, String>{r'$filter': "SpatialDim eq 'PER'"},
    );

    try {
      final respuesta = await _cliente.get(urlHwws).timeout(tiempoLimite);

      if (respuesta.statusCode != 200) {
        throw ApiException(
          'Código HTTP ${respuesta.statusCode} al consultar el indicador HWWS_1.',
        );
      }

      final Map<String, dynamic> decodificado =
          jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;

      final List<dynamic> crudos =
          decodificado['value'] as List<dynamic>? ?? const <dynamic>[];

      return crudos
          .whereType<Map<String, dynamic>>()
          .map(IndicadorHigiene.fromJson)
          .toList()
        ..sort((a, b) => a.anio.compareTo(b.anio));
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('La consulta del indicador HWWS_1 superó el tiempo límite.');
    } catch (e) {
      throw ApiException('Error al obtener indicador HWWS_1: $e');
    }
  }

  /// Cierra el cliente HTTP para liberar recursos.
  void cerrar() => _cliente.close();
}