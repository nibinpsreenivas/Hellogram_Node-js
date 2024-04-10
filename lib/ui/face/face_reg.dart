import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellogram/ui/face/face_search.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/screens/login/login_page.dart';
import 'package:hellogram/ui/screens/login/register_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FaceRegistrationScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> registerUser(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.219:5000/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'photo': base64Encode(_image!.readAsBytesSync()),
      }),
    );

    if (response.statusCode == 200) {
      print('User registered successfully');
      Fluttertoast.showToast(msg: "User registered successfully ");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage()));
    } else {
      throw Exception('Failed to register user');
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: hellotheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 55,
              width: size.width,
              child: Row(
                children: [
                  Image.asset(
                    'assets/img/hello.png',
                    height: 30,
                    color: hellotheme.secundary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                width: size.width,
                child: SvgPicture.asset(
                  'assets/svg/undraw_completed_m9ci.svg',
                ),
              ),
            ),
            TextCustom(
              text: 'Register !',
              letterSpacing: 2.0,
              color: hellotheme.background,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextCustom(
                text: 'Register your face first',
                textAlign: TextAlign.center,
                maxLines: 2,
                fontSize: 17,
                color: hellotheme.secundary,
              ),
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: TextFieldFrave(
                controller: usernameController,
                hintText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                height: 50,
                width: size.width,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        hellotheme.background1,
                        hellotheme.background,
                      ])),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0))),
                      child: TextCustom(
                          text: 'Capture and Register',
                          color: hellotheme.secundary,
                          fontSize: 20),
                      onPressed: () async {
                        await _pickImage();
                        if (_image != null) {
                          await registerUser(context);
                        }
                      }),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
