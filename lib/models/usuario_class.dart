class Usuario {
  String usuCI = "";
  String usuNombre = "";
  String usuPaterno = "";
  String usuMaterno = "";
  String usuEmail = "";
  String usuPass = "";
  String usuLat = "";
  String usuLng = "";
  String usuDireccion = "";
  bool usuBloqueado = false;
  int usuCantidadIntentos = 0;
  String usuFechaBloqueo = "2023-05-13 22:27";
  String usuFechaUltPass = "2023-05-13 22:27";

  Usuario();

  void getFromMap(Map<String, dynamic> usrData) {
    usuCI = usrData["usuCI"];
    usuNombre = usrData["usuNombre"];
    usuPaterno = usrData["usuPaterno"];
    usuMaterno = usrData["usuMaterno"];
    usuEmail = usrData["usuEmail"];
    usuPass = usrData["usuPass"];
    usuLat = usrData["usuLat"];
    usuLng = usrData["usuLng"];
    usuDireccion = usrData["usuDireccion"];
    usuBloqueado = usrData["usuBloqueado"];
    usuCantidadIntentos = usrData["usuCantidadIntentos"];
    usuFechaBloqueo = usrData["usuFechaBloqueo"];
    usuFechaUltPass = usrData["usuFechaUltPass"];
  }
}
