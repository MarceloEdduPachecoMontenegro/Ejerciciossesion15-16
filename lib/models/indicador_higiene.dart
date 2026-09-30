class IndicadorHigiene {
  static const String descripcion =
      'Población con instalaciones básicas de lavado de manos en el hogar (%)';

  final String codigoIndicador;
  final String pais;
  final int anio;
  final String ambito;
  final double? valor;

  const IndicadorHigiene({
    required this.codigoIndicador,
    required this.pais,
    required this.anio,
    required this.ambito,
    this.valor,
  });

  factory IndicadorHigiene.fromJson(Map<String, dynamic> json) {
    return IndicadorHigiene(
      codigoIndicador: json['IndicatorCode'] as String? ?? 'SIN_CODIGO',
      pais: json['SpatialDim'] as String? ?? 'N/D',
      anio: _aEntero(json['TimeDim']),
      ambito: _ambitoLegible(json['Dim1'] as String?),
      valor: _aDecimal(json['NumericValue']),
    );
  }

  bool get tieneValor => valor != null;

  String get valorTexto =>
      valor == null ? 'Sin dato' : '${valor!.toStringAsFixed(1)} %';

  double get fraccion => valor == null ? 0.0 : (valor! / 100).clamp(0.0, 1.0);

  static int _aEntero(dynamic valorCrudo) {
    if (valorCrudo is int) return valorCrudo;
    if (valorCrudo is num) return valorCrudo.toInt();
    if (valorCrudo is String) return int.tryParse(valorCrudo) ?? 0;
    return 0;
  }

  static double? _aDecimal(dynamic valorCrudo) {
    if (valorCrudo is num) return valorCrudo.toDouble();
    if (valorCrudo is String) return double.tryParse(valorCrudo);
    return null;
  }

  static String _ambitoLegible(String? dim1) {
    switch (dim1) {
      case 'RESIDENCEAREATYPE_RUR':
        return 'Rural';
      case 'RESIDENCEAREATYPE_URB':
        return 'Urbano';
      case 'RESIDENCEAREATYPE_TOTL':
        return 'Total';
      default:
        return 'General';
    }
  }
}