class Denuncia {
  int denId = 0;
  String denTitulo = "";
  String denDescripcion = "";
  int denTipo = 0;
  String denUsu = "";
  int denEstado = 0;
  String denFecha = "";
  String denHora = "";
  String denLat = "";
  String denLng = "";
  String denImagenes = "";

  Map<String, dynamic> toDbMap() {
    Map<String, dynamic> denData = {
      "denId": denId,
      "denTitulo": denTitulo,
      "denDescripcion": denDescripcion,
      "denTipo": denTipo,
      "denUsu": denUsu,
      "denEstado": denEstado,
      "denFecha": denFecha,
      "denHora": denHora,
      "denLat": denLat,
      "denLng": denLng,
      "denImagenes": denImagenes
    };
    return denData;
  }

  void fromDbMap(Map<String, dynamic> denData) {
    denId = denData["denId"];
    denTitulo = denData["denTitulo"];
    denDescripcion = denData["denDescripcion"];
    denTipo = denData["denTipo"];
    denUsu = denData["denUsu"];
    denEstado = denData["denEstado"];
    denFecha = denData["denFecha"];
    denHora = denData["denHora"];
    denLat = denData["denLat"];
    denLng = denData["denLng"];
    denImagenes = denData["denImagenes"];
  }
}
