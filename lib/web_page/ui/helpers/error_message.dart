import 'package:flutter/material.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

void errorMessageSnack(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: TextCustom(text: error, color: Colors.white),
    backgroundColor: Colors.red,
  ));
}
