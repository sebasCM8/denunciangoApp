import 'package:denunciango_app/models/apiendpoints_class.dart';
import 'package:denunciango_app/models/gettdresponse_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/tipoDenuncia_class.dart';
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
}
