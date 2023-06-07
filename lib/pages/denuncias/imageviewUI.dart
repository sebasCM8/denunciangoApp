import 'dart:convert';

import 'package:flutter/material.dart';

class ImageViewUI extends StatelessWidget {
  final String imgStr;
  const ImageViewUI({super.key, required this.imgStr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
              tag: "imageHero",
              child: Center(child: Image.memory(base64Decode(imgStr))))),
    );
  }
}
