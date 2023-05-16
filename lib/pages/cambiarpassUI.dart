import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:denunciango_app/pages/genericWidgets/formWidgets.dart';
import 'package:flutter/material.dart';

class CambiarPassUI extends StatefulWidget {
  final String usuEmail;
  const CambiarPassUI({super.key, required this.usuEmail});

  @override
  State<CambiarPassUI> createState() => _CambiarPassUIState();
}

class _CambiarPassUIState extends State<CambiarPassUI> {
  final _passCtrl = TextEditingController();
  final _rePassCtrl = TextEditingController();
  Usuario usu = Usuario();

  String _msgErr = "";
  bool _loading = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _rePassCtrl.dispose();

    super.dispose();
  }

  Future<ResponseResult> _actPassProc() async {
    ResponseResult result;
    try {
      if (_passCtrl.text.trim() == "" ||
          (_passCtrl.text.trim() != _rePassCtrl.text.trim())) {
        result = ResponseResult.full(false, "Las contraseñas no coinciden");
        return result;
      }
      usu.usuEmail = widget.usuEmail;
      usu.usuPass = _passCtrl.text.trim();
      result = await UsuarioController.actualizarPassUsr(usu);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }
    return result;
  }

  Future<void> cambiarPassBtn() async {
    setState(() {
      _loading = true;
    });

    _msgErr = "";
    ResponseResult procResp = await _actPassProc();
    if (procResp.ok) {
      Navigator.pushReplacementNamed(context, "/homePage");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        inputOne(_passCtrl, "Contraseña....", 50),
        inputOne(_passCtrl, "Confirmar contraseña..", 50),
        ElevatedButton(
            onPressed: cambiarPassBtn, child: const Text("CONFIRMAR"))
      ]),
    );
  }
}
