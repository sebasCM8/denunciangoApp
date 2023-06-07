import 'dart:convert';

import 'package:denunciango_app/controllers/denunciactrl_class.dart';
import 'package:denunciango_app/models/denimgresponse_class.dart';
import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:flutter/material.dart';

class DenDetalleUI extends StatefulWidget {
  final Denuncia den;
  const DenDetalleUI({super.key, required this.den});

  @override
  State<DenDetalleUI> createState() => _DenDetalleUIState();
}

class _DenDetalleUIState extends State<DenDetalleUI> {
  List<String> _imagenes = [];

  bool _loading = false;
  String _msgErr = "";

  @override
  void initState() {
    super.initState();
    getDenImagenes();
  }

  Future<void> getDenImagenes() async {
    setState(() {
      _loading = true;
    });

    try {
      DenImgResponse result =
          await DenunciaController.obtenerDenImagenes(widget.den.denId);
      if (result.resp.ok) {
        _imagenes = result.imgns;
      } else {
        _msgErr = result.resp.msg;
      }
    } catch (e) {
      _msgErr = "Excepcion: $e";
    }

    setState(() {
      _loading = false;
    });
  }

  Widget imagesList() {
    var devSize = MediaQuery.of(context).size;
    return Expanded(
      //height: devSize.height * 0.25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _imagenes.length,
          itemBuilder: (context, index) {
            String herotag = "imagen$index";
            return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/imageViewPage",
                      arguments: _imagenes[index]);
                },
                child: Hero(
                    tag: herotag,
                    child: Image.memory(base64Decode(_imagenes[index]))));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de denuncia")),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Text(
            widget.den.denTitulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Row(
            children: [
              const Text("Tipo: ", style: TextStyle(fontSize: 16)),
              Text(widget.den.denTd.tdTitulo,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const Text(", Estado: ", style: TextStyle(fontSize: 16)),
              Text(widget.den.denEstTitulo,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
          child: Text(widget.den.denDescripcion),
        ),
        if (_imagenes.isNotEmpty) imagesList(),
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
      ]),
    );
  }
}
