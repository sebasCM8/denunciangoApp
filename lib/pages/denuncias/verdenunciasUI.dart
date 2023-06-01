import 'package:flutter/material.dart';

class VerDenunciasUI extends StatefulWidget {
  const VerDenunciasUI({super.key});

  @override
  State<VerDenunciasUI> createState() => _VerDenunciasUIState();
}

class _VerDenunciasUIState extends State<VerDenunciasUI> {
  void registrarDenuncia() {
    Navigator.pushNamed(context, "/regDenunciaPage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis denuncias"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => registrarDenuncia(),
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add)),
      body: ListView(children: []),
    );
  }
}
