import 'package:flutter/material.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr_page extends StatefulWidget {
  const qr_page({Key? key}) : super(key: key);

  @override
  State<qr_page> createState() => _HomePageState();
}

class _HomePageState extends State<qr_page> {
  String? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hellotheme.primary,
      appBar: AppBar(
        title: Text(
          "User QR Code",
          style: TextStyle(color: hellotheme.secundary),
        ),
        backgroundColor: hellotheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            QrImageView(
              foregroundColor: hellotheme.background,
              data: hellotheme.username,
              padding: const EdgeInsets.all(0),
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: hellotheme.background,
              ),
            )
          ],
        ),
      ),
    );
  }
}
