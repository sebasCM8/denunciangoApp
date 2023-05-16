import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/cambiarpassresponse_class.dart';
import 'package:flutter/material.dart';

class LoadingUI extends StatefulWidget {
  const LoadingUI({super.key});

  @override
  State<LoadingUI> createState() => _LoadingUIState();
}

class _LoadingUIState extends State<LoadingUI> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    String usuEmail = await Future.delayed(
        const Duration(seconds: 1), () => UsuarioController.getUsuLogged());
    bool usuarioLogeado = (usuEmail != "");
    if (usuarioLogeado) {
      CambiarPasswordResponse apiResp =
          await UsuarioController.cambiarPasswordUsr(usuEmail);
      if (apiResp.resp.ok) {
        if (apiResp.cambiar) {
          Navigator.pushReplacementNamed(context, "/cambiarPasswordPage",
              arguments: usuEmail);
        } else {
          Navigator.pushReplacementNamed(context, "/homePage");
        }
      } else {
        Navigator.pushReplacementNamed(context, "/homePage");
      }
    } else {
      Navigator.pushReplacementNamed(context, "/inicioPage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 8)),
    );
  }
}
