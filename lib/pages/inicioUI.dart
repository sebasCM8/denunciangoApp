import 'dart:convert';
import 'dart:io';

import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/genericops_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:denunciango_app/pages/genericWidgets/formWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InicioUI extends StatefulWidget {
  const InicioUI({super.key});

  @override
  State<InicioUI> createState() => _InicioUIState();
}

class _InicioUIState extends State<InicioUI> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _ciCtrl = TextEditingController();
  File? _imgFile;
  String _imgStr = "";
  ImagePicker _imagePicker = ImagePicker();

  String _msgErr = "";
  bool _loading = false;
  Usuario _usu = Usuario();
  int _vista = 1;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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

  Future<ResponseResult> _loginProc() async {
    ResponseResult result;
    try {
      if (!GenericOps.checkValidEmail(_emailCtrl.text)) {
        result = ResponseResult.full(false, "Email no valido");
        return result;
      }
      if (_passwordCtrl.text == "") {
        result = ResponseResult.full(false, "Contraseña no valida");
        return result;
      }
      _usu.usuEmail = _emailCtrl.text;
      _usu.usuPass = _passwordCtrl.text;
      result = await UsuarioController.loginUsr(_usu);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }
    return Future.delayed(const Duration(seconds: 2), () => result);
  }

  Future<void> loginBtn() async {
    setState(() {
      _loading = true;
    });

    _msgErr = "";
    ResponseResult procResp = await _loginProc();
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

// ======= METODOS REGISTRO =======
  Future<void> selectImg() async {
    ImageSource src = ImageSource.camera;
    try {
      XFile? img = await _imagePicker.pickImage(source: src, imageQuality: 2);
      if (img == null) {
        return;
      }
      _imgFile = File(img.path);
      final bytes = await _imgFile!.readAsBytesSync();
      setState(() {
        _imgStr = base64Encode(bytes);
        print("IMAGE SIZE: ${_imgStr.length}");
      });
    } catch (e) {
      msgErrDialog(context, "Excepcion al cargar imagen");
    }
  }

  Future<ResponseResult> signupProc() async {
    ResponseResult result;
    try {
      if (!GenericOps.checkValidEntero(_ciCtrl.text)) {
        result = ResponseResult.full(false, "Carnet no valido");
        return result;
      }
      if (_imgStr == "") {
        result =
            ResponseResult.full(false, "Debe tomarse la foto para registrarse");
        return result;
      }

      _usu.usuCI = _ciCtrl.text.trim();
      result = await UsuarioController.checkCiImgUsr(_usu, _imgStr);
    } catch (e) {
      result =
          ResponseResult.full(false, "Excepcion al intentar registrarse: $e");
    }
    return Future.delayed(const Duration(seconds: 1), () => result);
  }

  Future<void> siguienteBtn() async {
    setState(() {
      _loading = true;
    });

    _msgErr = "";
    ResponseResult procResp = await signupProc();
    if (procResp.ok) {
      Navigator.pushNamed(context, "/registroPage", arguments: _usu);
    } else {
      _msgErr = procResp.msg;
      msgErrDialog(context, _msgErr);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    List<Widget> formulario;
    if (_vista == 1) {
      formulario = [
        inputOne(_emailCtrl, "Email....", 200),
        inputOne(_passwordCtrl, "Contraseña....", 50),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: loginBtn, child: const Text("INGRESAR"))))
      ];
    } else {
      formulario = [
        inputOne(_ciCtrl, "Carnet de identidad..", 15),
        Container(
          margin: const EdgeInsets.all(12),
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
          child: IconButton(
              onPressed: selectImg,
              icon: const Icon(Icons.image, color: Colors.white)),
        ),
        if (_imgStr != "")
          Container(
            width: devSize.width * 0.8,
            child: Image.file(_imgFile!),
          ),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: siguienteBtn,
                      child: const Text("REGISTRARME"))))
      ];
    }

    Widget lista = Expanded(
      child: ListView(
        children: formulario,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Column(children: [
        SizedBox(
          height: devSize.height * 0.10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (_vista == 1)
                    ? null
                    : () {
                        setState(() {
                          _vista = 1;
                          _usu = Usuario();
                        });
                      },
                child: const Text("Ingresar")),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
                onPressed: (_vista == 2)
                    ? null
                    : () {
                        setState(() {
                          _vista = 2;
                          _usu = Usuario();
                        });
                      },
                child: const Text("Registrarme"))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        lista,
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
      ]),
    );
  }
}
