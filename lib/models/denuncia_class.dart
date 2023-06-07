import 'package:denunciango_app/models/tipoDenuncia_class.dart';

class Denuncia {
  String denId = "";
  String denTitulo = "";
  String denDescripcion = "";
  String denUsu = "";
  int denEstado = 0;
  String denFecha = "";
  String denHora = "";
  String denLat = "";
  String denLng = "";
  String denImagenes = "";

  TipoDenuncia denTd = TipoDenuncia();
  String denEstTitulo = "";

  Map<String, dynamic> toDbMap() {
    Map<String, dynamic> denData = {
      "denId": denId,
      "denTitulo": denTitulo,
      "denDescripcion": denDescripcion,
      "denTipo": denTd.tdId,
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
    denUsu = denData["denUsu"];
    denEstado = denData["denEstado"];
    denFecha = denData["denFecha"];
    denHora = denData["denHora"];
    denLat = denData["denLat"];
    denLng = denData["denLng"];
    denImagenes = denData["denImagenes"];

    denTd.tdId = denData["denTipo"];
    denTd.tdTitulo = denData["denTdTitulo"];
    denEstTitulo = denData["denEstTitulo"];
  }
}
