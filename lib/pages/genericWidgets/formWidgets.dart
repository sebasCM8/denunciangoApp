import 'package:flutter/material.dart';

Widget inputOne(TextEditingController ctrl, String hintStr, int txtMaxLength) {
  return Container(
    margin: const EdgeInsets.only(left: 10, right: 10),
    child: TextField(
      controller: ctrl,
      maxLength: txtMaxLength,
      decoration: InputDecoration(
          hintText: hintStr, border: const OutlineInputBorder()),
    ),
  );
}