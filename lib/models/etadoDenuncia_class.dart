class EstadoDenuncia {
  int estId = 0;
  String estTitulo = "";

  getFromDb(Map<String, dynamic> estData) {
    estId = estData["estId"];
    estTitulo = estData["estTitulo"];
  }
}
