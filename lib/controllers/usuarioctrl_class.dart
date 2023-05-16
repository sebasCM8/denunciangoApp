import 'package:denunciango_app/models/apiendpoints_class.dart';
import 'package:denunciango_app/models/cambiarpassresponse_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioController {
  static String cUSUEMAIL = "usuEmail";

  static Future<ResponseResult> loginUsr(Usuario usu) async {
    ResponseResult result = ResponseResult();

    Map<String, dynamic> theData = {"email": usu.usuEmail, "pass": usu.usuPass};
    String theUrl = ApiEndpoints.apiLogin;
    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.getFromAPI(apiResp);
    if (result.ok) {
      usu.getFromMap(apiResp["data"]);
      await createSession(usu.usuEmail);
    }

    return result;
  }

  static Future<CambiarPasswordResponse> cambiarPasswordUsr(
      String email) async {
    CambiarPasswordResponse result = CambiarPasswordResponse();
    try {
      Map<String, dynamic> theData = {"email": email};
      String theUrl = ApiEndpoints.apiCambiarPassword;
      final apiReq = await http.post(Uri.parse(theUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(theData));
      var apiResp = jsonDecode(apiReq.body);
      result.resp.getFromAPI(apiResp);
      if (result.resp.ok) {
        result.cambiar = apiResp["data"];
      }
    } catch (e) {
      result.resp = ResponseResult.full(false, "Excepcion: $e");
    }

    return result;
  }

  static Future<ResponseResult> actualizarPassUsr(Usuario usr) async {
    ResponseResult result = ResponseResult();
    try {
      Map<String, dynamic> theData = {
        "email": usr.usuEmail,
        "pass": usr.usuPass
      };
      String theUrl = ApiEndpoints.apiActualizarPassword;
      final apiReq = await http.post(Uri.parse(theUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(theData));
      var apiResp = jsonDecode(apiReq.body);
      result.getFromAPI(apiResp);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }
    return result;
  }

  static Future<void> createSession(String usuEmail) async {
    final prefs = await SharedPreferences.getInstance();
    String currentUsu = prefs.getString(cUSUEMAIL) ?? "";
    if (currentUsu != "") {
      await destroySession();
    }
    await prefs.setString(cUSUEMAIL, usuEmail);
  }

  static Future<void> destroySession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cUSUEMAIL);
  }

  static Future<String> getUsuLogged() async {
    final prefs = await SharedPreferences.getInstance();
    String currentUsu = prefs.getString(cUSUEMAIL) ?? "";
    return currentUsu;
  }
}
