import 'dart:convert';
import 'dart:io';

import 'package:denunciango_app/controllers/denunciactrl_class.dart';
import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:denunciango_app/models/genericops_class.dart';
import 'package:denunciango_app/models/gettdresponse_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/tipoDenuncia_class.dart';
import 'package:denunciango_app/pages/genericWidgets/formWidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class RegDenunciaUI extends StatefulWidget {
  const RegDenunciaUI({super.key});

  @override
  State<RegDenunciaUI> createState() => _RegDenunciaUIState();
}

class _RegDenunciaUIState extends State<RegDenunciaUI> {
  bool _loading = false;
  String _msgErr = "";

  List<TipoDenuncia> _tiposDenuncia = [];
  int _tipoDenSelected = 0;

  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final int cMAXHEIGHT = 800;
  final int cMAXWIDTH = 1024;
  final int cMAXIMAGENES = 2;
  final int cMINDESC = 64;
  final int cMAXDESC = 512;

  List<File> _imagenes = [];

  @override
  void initState() {
    super.initState();
    getTds();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> getTds() async {
    setState(() {
      _loading = true;
    });
    GetTdResponse apiResp = GetTdResponse();
    try {
      apiResp = await DenunciaController.getTiposDenuncia();
      if (apiResp.resp.ok) {
        _tiposDenuncia = apiResp.tdList;
        _tipoDenSelected = _tiposDenuncia[0].tdId;
      } else {
        _msgErr = apiResp.resp.msg;
      }
    } catch (e) {
      apiResp.resp = ResponseResult.full(false, "Excepcion: $e");
      _msgErr = apiResp.resp.msg;
    }
    setState(() {
      _loading = false;
    });
  }

  Widget tdDropDownBtn() {
    List<DropdownMenuItem> opts = [];
    for (TipoDenuncia td in _tiposDenuncia) {
      DropdownMenuItem opt =
          DropdownMenuItem(value: td.tdId, child: Text(td.tdTitulo.trim()));
      opts.add(opt);
    }

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, right: 8),
          child: const Text(
            "Tipo de denuncia:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton(
            items: opts,
            value: _tipoDenSelected,
            onChanged: (dynamic val) {
              setState(() {
                _tipoDenSelected = val;
              });
            }),
      ],
    );
  }

  Future<void> selectImageRestricted(int imgSrc) async {
    ImageSource imgSource =
        (imgSrc == 0) ? ImageSource.camera : ImageSource.gallery;
    try {
      ImagePicker imgPicker = ImagePicker();
      XFile? img = await imgPicker.pickImage(
          source: imgSource,
          imageQuality: 10,
          maxHeight: cMAXHEIGHT.toDouble(),
          maxWidth: cMAXWIDTH.toDouble());
      if (img == null) return;

      File imgFile = File(img.path);
      if (_imagenes.length == cMAXIMAGENES) {
        _imagenes.removeLast();
      }
      setState(() {
        _imagenes.insert(0, imgFile);
      });
      //final bytes = imgFile!.readAsBytesSync();
      //String _imgStr = base64Encode(bytes);
    } catch (e) {
      print("Excepcion al seleccionar imagen: $e");
    }
  }

  Future<void> selectImgDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Seleccionar imagen"),
            actions: [
              TextButton(
                  onPressed: () => selectImageRestricted(0),
                  child: const Text("CAMARA")),
              TextButton(
                  onPressed: () => selectImageRestricted(1),
                  child: const Text("GALERIA"))
            ],
          );
        });
  }

  Widget imagesList() {
    var devSize = MediaQuery.of(context).size;
    return Container(
      height: devSize.height * 0.25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _imagenes.length,
          itemBuilder: (context, index) {
            return Image.file(_imagenes[index]);
          }),
    );
  }

  Future<ResponseResult> regDenProc() async {
    ResponseResult result;

    try {
      Denuncia denObj = Denuncia();
      if (_tituloCtrl.text.trim() == "") {
        result = ResponseResult.full(false, "Debe colocar titulo a la denucia");
        return result;
      }
      if (_descCtrl.text.trim().length < cMINDESC ||
          _descCtrl.text.trim().length > cMAXDESC) {
        result = ResponseResult.full(false,
            "La descripcion debe tener al menos $cMINDESC y maximo $cMAXDESC caracteres");
        return result;
      }
      denObj.denTitulo = _tituloCtrl.text.trim();
      denObj.denDescripcion = _descCtrl.text.trim();
      denObj.denTd.tdId = _tipoDenSelected;

      if (_imagenes.isEmpty) {
        result = ResponseResult.full(false, "Debe tomar almenos una foto");
        return result;
      }
      List<String> denImagenes = [];
      for (File f in _imagenes) {
        final bytes = f.readAsBytesSync();
        String imgStr = base64Encode(bytes);
        denImagenes.add(imgStr);
      }

      bool hasPermission = await GenericOps.handleLocationPermission();
      if (!hasPermission) {
        result = ResponseResult.full(false, "Debe dar permiso de ubicacion");
        return result;
      }
      Location lc = Location();
      LocationData lcData = await lc.getLocation();
      denObj.denLat = lcData.latitude.toString();
      denObj.denLng = lcData.longitude.toString();

      denObj.denUsu = await UsuarioController.getUsuLogged();

      result = await DenunciaController.registrarDenuncia(denObj, denImagenes);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }

    return Future.delayed(const Duration(seconds: 1), () => result);
  }

  Future<void> registrarDen() async {
    setState(() {
      _loading = true;
    });
    _msgErr = "";

    ResponseResult procResp = await regDenProc();
    if (procResp.ok) {
      Navigator.pop(context);
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

    Widget tdDdnBtn = (_tiposDenuncia.isNotEmpty)
        ? tdDropDownBtn()
        : const SizedBox(
            height: 1,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar denuncia"),
      ),
      body: ListView(children: [
        tdDdnBtn,
        inputOne(_tituloCtrl, "Titulo de la denuncia...", 100),
        inputTextArea(_descCtrl, "Descripcion de la denuncia......", cMAXDESC),
        imagesList(),
        Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
          child: IconButton(
            onPressed: () => selectImgDialog(context),
            icon: const Icon(
              Icons.image,
              color: Colors.white,
            ),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black)),
          ),
        ),
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
        if (_msgErr != "")
          Container(
              alignment: Alignment.center,
              child: Text(
                _msgErr,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              )),
        const SizedBox(
          height: 25,
        ),
        if (!_loading)
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(devSize.width * 0.75, 70)),
              onPressed: registrarDen,
              child: const Text(
                "ENVIAR",
                style: TextStyle(fontSize: 20),
              ))
      ]),
    );
  }
}
