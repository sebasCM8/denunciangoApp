class TipoDenuncia {
  String tdId = "";
  String tdTitulo = "";

  TipoDenuncia();

  void getFromDb(Map<String, dynamic> tdData) {
    tdId = tdData["tdId"];
    tdTitulo = tdData["tdTitulo"];
  }
}
