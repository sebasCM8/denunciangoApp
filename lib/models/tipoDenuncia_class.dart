class TipoDenuncia {
  int tdId = 0;
  String tdTitulo = "";

  TipoDenuncia();

  void getFromDb(Map<String, dynamic> tdData) {
    tdId = int.parse(tdData["tdId"]);
    tdTitulo = tdData["tdTitulo"];
  }
}
