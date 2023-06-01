import 'package:denunciango_app/models/usuario_class.dart';
import 'package:denunciango_app/pages/cambiarpassUI.dart';
import 'package:denunciango_app/pages/denuncias/regDenunciaUI.dart';
import 'package:denunciango_app/pages/denuncias/verdenunciasUI.dart';
import 'package:denunciango_app/pages/homeUI.dart';
import 'package:denunciango_app/pages/inicioUI.dart';
import 'package:denunciango_app/pages/loadingUI.dart';
import 'package:denunciango_app/pages/registroUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'Denunciango App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoadingUI(),
        '/inicioPage': (context) => const InicioUI(),
        '/homePage': (context) => const HomeUI(),
        '/cambiarPasswordPage':(context) => CambiarPassUI(usuEmail: ModalRoute.of(context)!.settings.arguments as String),
        '/registroPage':(context) => RegistroUI(usu: ModalRoute.of(context)!.settings.arguments as Usuario),
        '/verDenunciasPage': (context) => const VerDenunciasUI(),
        '/regDenunciaPage': (context) => const RegDenunciaUI()
      },
    );
  }
}
