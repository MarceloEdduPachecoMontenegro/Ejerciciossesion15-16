class Publicacion {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Publicacion({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}