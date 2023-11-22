import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/codverresponse_class.dart';
import 'package:denunciango_app/models/genericops_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:denunciango_app/pages/genericWidgets/formWidgets.dart';
import 'package:flutter/material.dart';

class RegistroUI extends StatefulWidget {
  final Usuario usu;
  const RegistroUI({super.key, required this.usu});

  @override
  State<RegistroUI> createState() => _RegistroUIState();
}

class _RegistroUIState extends State<RegistroUI> {
  final _direccionCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _rePassCtrl = TextEditingController();
  final _codeVerCtrl = TextEditingController();
  bool _loading = false;
  String _msgErr = "";

  String _codeVerificacion = "";
  bool _setCode = false;
  int _vista = 1;

  @override
  void dispose() {
    _direccionCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _rePassCtrl.dispose();
    _codeVerCtrl.dispose();
    super.dispose();
  }

  Future<CodVerResponse> envCodProc() async {
    CodVerResponse result = CodVerResponse();
    try {
      if (!GenericOps.checkValidEmail(_emailCtrl.text.trim())) {
        result.resp = ResponseResult.full(false, "correo invalido");
        return result;
      }
      if (_direccionCtrl.text == "") {
        result.resp = ResponseResult.full(false, "direccion invalida");
        return result;
      }
      widget.usu.usuEmail = _emailCtrl.text.trim();
      widget.usu.usuDireccion = _direccionCtrl.text.trim();
      result = await UsuarioController.envCodCorreoUsr(widget.usu);
    } catch (e) {
      result.resp = ResponseResult.full(false, "Excepcion: $e");
    }

    return Future.delayed(const Duration(seconds: 2), () => result);
  }

  Future<void> envCodBtn() async {
    setState(() {
      _loading = true;
    });

    CodVerResponse procResp = await envCodProc();
    if (procResp.resp.ok) {
      _setCode = true;
      _codeVerificacion = procResp.code.toString();
    } else {
      _msgErr = procResp.resp.msg;
      msgErrDialog(context, _msgErr);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<ResponseResult> signupProc() async {
    ResponseResult result;

    try {
      if (_passCtrl.text.trim() == "" ||
          (_passCtrl.text.trim() != _rePassCtrl.text.trim())) {
        result = ResponseResult.full(false, "correo invalido");
        return result;
      }
      widget.usu.usuPass = _passCtrl.text.trim();
      result = await UsuarioController.registrarUsr(widget.usu);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }

    return result;
  }

  Future<void> signupBtn() async {
    setState(() {
      _loading = true;
    });

    ResponseResult procResp = await signupProc();
    if (procResp.ok) {
      try {
        ResponseResult tknResp =
            await UsuarioController.registrarTokenDisp(widget.usu.usuEmail);
        if (!tknResp.ok) {
          print("Excepcion al registrar token ${tknResp.msg}");
        }
      } catch (e) {
        print("Excepcion al registrar token $e");
      }

      Navigator.pushNamedAndRemoveUntil(
          context, '/homePage', (Route<dynamic> route) => false);
    } else {
      _msgErr = procResp.msg;
      msgErrDialog(context, _msgErr);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> msgErrDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              msg,
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    List<Widget> formulario;
    if (_vista == 1) {
      formulario = [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Nro. CI: ${widget.usu.usuCI}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Nombre: ${widget.usu.usuNombre}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Apellido Paterno: ${widget.usu.usuPaterno}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Apellido Materno: ${widget.usu.usuMaterno}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        inputOne(_direccionCtrl, "direccion....", 100),
        inputOne(_emailCtrl, "Email....", 100),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: envCodBtn,
                      child: const Text("Enviar Codigo")))),
        if (_setCode)
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: _codeVerCtrl,
              maxLength: 4,
              onChanged: (text) {
                if (text == _codeVerificacion) {
                  setState(() {
                    _vista = 2;
                  });
                }
              },
              decoration: const InputDecoration(
                  hintText: "Codigo de verificacion",
                  border: OutlineInputBorder()),
            ),
          ),
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
      ];
    } else {
      formulario = [
        inputOne(_passCtrl, "Contraseña....", 50),
        inputOne(_rePassCtrl, "Confirmar contraseña..", 50),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: signupBtn, child: const Text("INGRESAR")))),
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
      ),
      body: ListView(children: formulario),
    );
  }
}
