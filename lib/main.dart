import 'package:denunciango_app/controllers/usuarioctrl_class.dart';
import 'package:denunciango_app/models/denuncia_class.dart';
import 'package:denunciango_app/models/resultresponse_class.dart';
import 'package:denunciango_app/models/usuario_class.dart';
import 'package:denunciango_app/pages/cambiarpassUI.dart';
import 'package:denunciango_app/pages/denuncias/denDetalleUI.dart';
import 'package:denunciango_app/pages/denuncias/imageviewUI.dart';
import 'package:denunciango_app/pages/denuncias/regDenunciaUI.dart';
import 'package:denunciango_app/pages/denuncias/verdenunciasUI.dart';
import 'package:denunciango_app/pages/homeUI.dart';
import 'package:denunciango_app/pages/inicioUI.dart';
import 'package:denunciango_app/pages/loadingUI.dart';
import 'package:denunciango_app/pages/registroUI.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    String usuEmail = await UsuarioController.getUsuLogged();
    if (usuEmail != "") {
      ResponseResult resp =
          await UsuarioController.registrarTokenDisp(usuEmail);
      if (!resp.ok) {
        print("EXCEP: ${resp.msg}");
      }
    }
  }).onError((err) {
    print("EXCEP: $err");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print("MESSAGE DATA: ${message.data}");
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
        '/cambiarPasswordPage': (context) => CambiarPassUI(
            usuEmail: ModalRoute.of(context)!.settings.arguments as String),
        '/registroPage': (context) => RegistroUI(
            usu: ModalRoute.of(context)!.settings.arguments as Usuario),
        '/verDenunciasPage': (context) => const VerDenunciasUI(),
        '/regDenunciaPage': (context) => const RegDenunciaUI(),
        '/verDenDetallePage': (context) => DenDetalleUI(
              den: ModalRoute.of(context)!.settings.arguments as Denuncia,
            ),
        '/imageViewPage': (context) => ImageViewUI(
            imgStr: ModalRoute.of(context)!.settings.arguments as String)
      },
    );
  }
}
