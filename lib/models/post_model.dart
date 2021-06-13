
class PostModel {
  String? id;
  String? titulo;
  String? contenido;
  List<String>? enlaces;
  List<String>? hashtags;
  List<String>? idUser;
  int? votos;
  String? fecha;

  PostModel({
    this.id,
    this.titulo,
    this.contenido,
    this.enlaces,
    this.hashtags,
    this.idUser,
    this.votos,
    this.fecha
  });

}