import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FaceRecognitionScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> compareFaces(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.219:5000/compare'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'photo': base64Encode(_image!.readAsBytesSync()),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Match found for user: ${data['username']}');
    } else {
      print('No match found');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facial Recognition'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
                if (_image != null) {
                  await compareFaces(context);
                }
              },
              child: Text('Capture and Recognize'),
            ),
          ],
        ),
      ),
    );
  }
}
