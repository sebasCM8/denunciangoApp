import 'package:denunciango_app/controllers/denunciactrl_class.dart';
import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:denunciango_app/models/etadoDenuncia_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/tipoDenuncia_class.dart';
import 'package:denunciango_app/models/usuDen_class.dart';
import 'package:flutter/material.dart';

class VerDenunciasUI extends StatefulWidget {
  const VerDenunciasUI({super.key});

  @override
  State<VerDenunciasUI> createState() => _VerDenunciasUIState();
}

class _VerDenunciasUIState extends State<VerDenunciasUI> {
  List<Denuncia> _denunciasFull = [];
  List<Denuncia> _denuncias = [];

  List<TipoDenuncia> _tiposDenuncia = [];
  int _tipoDenSelected = 0;

  List<EstadoDenuncia> _estadosDenuncia = [];
  int _estadoDenSelected = -1;

  String _fIni = "";
  String _fFin = "";
  DateTime? dIni;
  DateTime? dFin;

  bool _loading = false;
  String _msgErr = "";

  @override
  void initState() {
    super.initState();
    getDenuncias();
  }

  Widget tdDropDownBtn() {
    List<DropdownMenuItem> opts = [];
    opts.add(const DropdownMenuItem(value: 0, child: Text("TODOS")));
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
                applyFilter();
              });
            }),
      ],
    );
  }

  Widget estDropDownBtn() {
    List<DropdownMenuItem> opts = [];
    opts.add(const DropdownMenuItem(value: -1, child: Text("TODOS")));
    for (EstadoDenuncia est in _estadosDenuncia) {
      DropdownMenuItem opt =
          DropdownMenuItem(value: est.estId, child: Text(est.estTitulo.trim()));
      opts.add(opt);
    }

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15, right: 8),
          child: const Text(
            "Estados de denuncia:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton(
            items: opts,
            value: _estadoDenSelected,
            onChanged: (dynamic val) {
              setState(() {
                _estadoDenSelected = val;
                applyFilter();
              });
            }),
      ],
    );
  }

  Future<void> getDenuncias() async {
    setState(() {
      _loading = true;
    });
    UsuDenResponse apiResp = UsuDenResponse();
    try {
      apiResp = await DenunciaController.obtenerUsuDen();
      if (apiResp.resp.ok) {
        _denuncias = apiResp.denList;
        _denunciasFull = List.from(_denuncias);
        _tiposDenuncia = apiResp.tdList;
        _estadosDenuncia = apiResp.estList;
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

  Widget denunciasList() {
    var devSize = MediaQuery.of(context).size;
    return Expanded(
      child: ListView.builder(
          itemCount: _denuncias.length,
          itemBuilder: (context, index) {
            return Container(
              //height: devSize.height * 0.20,
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(1, 1),
                        blurRadius: 4),
                    BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(-1, -1),
                        blurRadius: 4)
                  ],
                  border: Border.all(
                      color: Colors.purple, width: 2, style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(Radius.circular(11))),
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      _denuncias[index].denTitulo,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: Text(
                        "Tipo: ${_denuncias[index].denTd.tdTitulo.toString()}",
                        style: const TextStyle(fontSize: 16))),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: Text("Estado: ${_denuncias[index].denEstTitulo}")),
                Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.bottomRight,
                    child: Text(
                        "${_denuncias[index].denFecha} - ${_denuncias[index].denHora}",
                        style: const TextStyle(fontSize: 16)))
              ]),
            );
          }),
    );
  }

  void registrarDenuncia() {
    Navigator.pushNamed(context, "/regDenunciaPage")
        .then((value) => getDenuncias());
  }

  void applyFilter() {
    bool seFiltro = false;

    if (_fIni != "" && _fFin != "") {
      seFiltro = true;
      DateTime d1 = DateTime.parse(_fIni);
      DateTime d2 = DateTime.parse(_fFin);

      _denuncias.clear();
      for (Denuncia den in _denunciasFull) {
        var dateParts = den.denFecha.split("-");
        if (int.parse(dateParts[1]) < 10 && dateParts[1].length < 2) {
          dateParts[1] = "0${dateParts[1]}";
        }
        if (int.parse(dateParts[2]) < 10 && dateParts[2].length < 2) {
          dateParts[2] = "0${dateParts[2]}";
        }
        String fullDate = "${dateParts[0]}-${dateParts[1]}-${dateParts[2]}";
        DateTime xdate = DateTime.parse(fullDate);
        int d1Comp = xdate.compareTo(d1);
        int d2Comp = xdate.compareTo(d2);
        if (d1Comp >= 0 && d2Comp <= 0) {
          _denuncias.add(den);
        }
      }
    }

    if (_tipoDenSelected != 0) {
      List<Denuncia> srcList =
          seFiltro ? List.from(_denuncias) : _denunciasFull;
      seFiltro = true;

      _denuncias.clear();
      for (Denuncia den in srcList) {
        if (den.denTd.tdId == _tipoDenSelected) {
          _denuncias.add(den);
        }
      }
    }

    if (_estadoDenSelected != -1) {
      List<Denuncia> srcList =
          seFiltro ? List.from(_denuncias) : _denunciasFull;
      seFiltro = true;

      _denuncias.clear();
      for (Denuncia den in srcList) {
        if (den.denEstado == _estadoDenSelected) {
          _denuncias.add(den);
        }
      }
    }

    if (!seFiltro) {
      _denuncias = List.from(_denunciasFull);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tdDdnBtn = (_tiposDenuncia.isNotEmpty)
        ? tdDropDownBtn()
        : const SizedBox(
            height: 1,
          );

    Widget estDdnBtn = (_estadosDenuncia.isNotEmpty)
        ? estDropDownBtn()
        : const SizedBox(
            height: 1,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis denuncias"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => registrarDenuncia(),
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: const Text("Del"),
                ),
                TextButton(
                    onPressed: () async {
                      dIni = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now());
                      if (dIni != null) {
                        setState(() {
                          _fIni = dIni.toString().split(" ")[0];
                          applyFilter();
                        });
                      }
                    },
                    child: Text(_fIni == "" ? "toca" : _fIni)),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text("al"),
                ),
                TextButton(
                    onPressed: () async {
                      dFin = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now());
                      if (dFin != null) {
                        setState(() {
                          _fFin = dFin.toString().split(" ")[0];
                          applyFilter();
                        });
                      }
                    },
                    child: Text(_fFin == "" ? "toca" : _fFin)),
              ],
            ),
          ),
          tdDdnBtn,
          estDdnBtn,
          denunciasList(),
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
        ],
      ),
    );
  }
}
