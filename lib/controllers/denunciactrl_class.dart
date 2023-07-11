import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/apiendpoints_class.dart';
import 'package:denunciango_app/models/denimgresponse_class.dart';
import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:denunciango_app/models/etadoDenuncia_class.dart';
import 'package:denunciango_app/models/gettdresponse_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/tipoDenuncia_class.dart';
import 'package:denunciango_app/models/usuDen_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DenunciaController {
  static Future<GetTdResponse> getTiposDenuncia() async {
    GetTdResponse result = GetTdResponse();

    String theUrl = ApiEndpoints.apiGetTiposDenuncias;
    final apiReq = await http.get(Uri.parse(theUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });
    var apiResp = jsonDecode(apiReq.body);
    result.resp.getFromAPI(apiResp);
    if (result.resp.ok) {
      for (var item in apiResp["data"]) {
        TipoDenuncia aTd = TipoDenuncia();
        aTd.getFromDb(item);
        result.tdList.add(aTd);
      }
    }

    return result;
  }

  static Future<ResponseResult> registrarDenuncia(
      Denuncia denObj, List<String> denImagenes) async {
    ResponseResult result = ResponseResult();

    Map<String, dynamic> theData = denObj.toDbMap();
    theData["images"] = denImagenes;
    String theUrl = ApiEndpoints.apiRegistrarDenuncia;

    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.getFromAPI(apiResp);

    return result;
  }

  static Future<UsuDenResponse> obtenerUsuDen() async {
    UsuDenResponse result = UsuDenResponse();
    result.resp = ResponseResult();

    Map<String, dynamic> theData = {
      "usuEmail": await UsuarioController.getUsuLogged()
    };
    String theUrl = ApiEndpoints.apiUsuarioDenuncias;

    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.resp.getFromAPI(apiResp);
    if (result.resp.ok) {
      for (var item in apiResp["data"]["denuncias"]) {
        Denuncia den = Denuncia();
        den.fromDbMap(item);
        result.denList.add(den);
      }

      for (var item in apiResp["data"]["ests"]) {
        EstadoDenuncia est = EstadoDenuncia();
        est.getFromDb(item);
        result.estList.add(est);
      }

      for (var item in apiResp["data"]["tds"]) {
        TipoDenuncia td = TipoDenuncia();
        td.getFromDb(item);
        result.tdList.add(td);
      }
    }

    return result;
  }

  static Future<DenImgResponse> obtenerDenImagenes(String denId) async {
    DenImgResponse result = DenImgResponse();

    Map<String, dynamic> theData = {"denId": denId};
    String theUrl = ApiEndpoints.apiDenImagenes;
    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.resp.getFromAPI(apiResp);
    if (result.resp.ok) {
      for (var item in apiResp["data"]["denImagenes"]) {
        result.imgns.add(item);
      }
    }

    return result;
  }
}
