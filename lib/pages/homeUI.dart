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

  void logoutBtn() {}

  @override
  Widget build(BuildContext context) {
    Widget myDrawer = Drawer(
        child: ListView(children: [
      const SizedBox(
        height: 120,
        child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white),
            )),
      ),
      ListTile(
        title: const Text("Salir"),
        onTap: logoutBtn,
      ),
    ]));

    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      drawer: myDrawer,
      body: Center(child: Text("Bienvenido ${_usu.usuEmail}")),
    );
  }
}
