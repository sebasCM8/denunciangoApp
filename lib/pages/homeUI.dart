import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  Usuario _usu = Usuario();

  @override
  void initState() {
    super.initState();
    checkPassword();
  }

  Future<void> checkPassword() async {
    String usuEmail = await UsuarioController.getUsuLogged();
    setState(() {
      _usu.usuEmail = usuEmail;
    });
  }

  Future<void> logoutProc() async {
    await UsuarioController.destroySession();
    Navigator.pushNamedAndRemoveUntil(
        context, '/inicioPage', (Route<dynamic> route) => false);
  }

  Future<void> confimarDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Seguro que desea cerrrar sesion?",
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "NO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    logoutProc();
                  },
                  child: const Text(
                    "SI SALIR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ))
            ],
          );
        });
  }

  void verMisDenuncias() {
    Navigator.pushNamed(context, "/verDenunciasPage");
  }

  @override
  Widget build(BuildContext context) {
    Widget myDrawer = Drawer(
        child: ListView(children: [
      const SizedBox(
        height: 120,
        child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white),
            )),
      ),
      ListTile(
        title: const Text(
          "Mis denuncias",
        ),
        onTap: verMisDenuncias,
      ),
      const SizedBox(
        height: 50,
      ),
      ListTile(
        title: const Text(
          "Salir",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () => confimarDialog(context),
      ),
    ]));

    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      drawer: myDrawer,
      body: Center(child: Text("Bienvenido ${_usu.usuEmail}")),
    );
  }
}
