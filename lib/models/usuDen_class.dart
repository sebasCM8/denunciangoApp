import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:denunciango_app/models/etadoDenuncia_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/tipoDenuncia_class.dart';

class UsuDenResponse {
  ResponseResult resp = ResponseResult();
  List<Denuncia> denList = [];
  List<TipoDenuncia> tdList = [];
  List<EstadoDenuncia> estList = [];
}
