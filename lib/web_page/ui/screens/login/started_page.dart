import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hellogram/web_page/ui/helpers/helpers.dart';
import 'package:hellogram/web_page/ui/screens/emotion/emotion.dart';
import 'package:hellogram/web_page/ui/screens/login/login_page.dart';
import 'package:hellogram/web_page/ui/screens/login/register_page.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class StartedPageweb extends StatefulWidget {
  const StartedPageweb({Key? key}) : super(key: key);

  @override
  State<StartedPageweb> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPageweb> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  String mood = "";
  String face = "emotion";

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: true,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> sendRequestToServer(String imageDataUrl) async {
    final bytes = base64.decode(imageDataUrl.split(',').last);
    final response = await http.post(
      Uri.parse('http://192.168.236.74:5000/predict'),
      body: {'image': base64Encode(bytes)},
    );
    final jsonData = jsonDecode(response.body);
    print(jsonData['emotion']);

    setState(() {
      face = jsonData['emotion'];
    });
    print(face);
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
                  const TextCustom(text: ' Social', fontSize: 17),
                  SizedBox(
                    width: 780,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              hellotheme.primary,
                              hellotheme.background1,
                              hellotheme.primary,
                            ])),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0))),
                            child: TextCustom(
                                text: 'Log in',
                                color: hellotheme.secundary,
                                fontSize: 20),
                            onPressed: () {
                              captureImage();
                              Navigator.push(
                                  context, routeSlide(page: const LoginPage()));
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              hellotheme.primary,
                              hellotheme.background1,
                              hellotheme.primary,
                            ])),
                        child: TextButton(
                          child: TextCustom(
                            text: 'Sign up',
                            fontSize: 20,
                            color: hellotheme.secundary,
                          ),
                          onPressed: () => Navigator.push(
                              context, routeSlide(page: RegisterPage())),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                width: size.width,
                child: SvgPicture.asset(
                  'assets/svg/undraw_social_influencer_re_beim.svg',
                ),
              ),
            ),
            TextCustom(
              text: 'Welcome !',
              letterSpacing: 2.0,
              color: hellotheme.background,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextCustom(
                text:
                    'The best place to write stories and share your experiences.',
                textAlign: TextAlign.center,
                maxLines: 2,
                fontSize: 17,
                color: hellotheme.secundary,
              ),
            ),
            const SizedBox(height: 40.0),
            const SizedBox(height: 20.0),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void captureImage() async {
    try {
      final XFile image = await _cameraController.takePicture();
      final imageDataUrl = await image.readAsBytes();
      sendRequestToServer(base64Encode(imageDataUrl)).then((_) {
        Fluttertoast.showToast(msg: "Image sent to server successfully!");
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  void extractData(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    List<Face> faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty && faces[0].smilingProbability != null) {
      double? prob = faces[0].smilingProbability;

      if (prob! > 0.8) {
        setState(() {
          mood = "Happy";
          Emotion.emotion = "happy";
          Fluttertoast.showToast(msg: "hey good to see you happy and $face ");
          hellotheme.primary = Colors.black;
          hellotheme.secundary = Colors.white;
          hellotheme.background = Color.fromARGB(255, 128, 0, 126);
          hellotheme.background1 = Color.fromARGB(125, 154, 8, 152);
        });
      } else if (prob > 0.3 && prob < 0.8) {
        setState(() {
          mood = "Normal";
          Emotion.emotion = "normal";
          Fluttertoast.showToast(msg: "hey good to see you normal and $face");
          hellotheme.primary = Colors.black;
          hellotheme.secundary = Colors.white;
          hellotheme.background = Color.fromARGB(255, 128, 0, 126);
          hellotheme.background1 = Color.fromARGB(125, 154, 8, 152);
        });
      } else if (prob > 0.06152385 && prob < 0.3) {
        setState(() {
          mood = "Sad";
          Emotion.emotion = "sad";
          Fluttertoast.showToast(msg: "Hey why are you Sad and $face");
          hellotheme.primary = Colors.white;
          hellotheme.secundary = Colors.black;
          hellotheme.background = Color.fromARGB(255, 128, 0, 126);
          hellotheme.background1 = Color.fromARGB(125, 154, 8, 152);
        });
      } else {
        setState(() {
          mood = "Angry";
          Emotion.emotion = "Angry";
          Fluttertoast.showToast(msg: "Hey why are you Angry and $face");
          hellotheme.primary = Colors.white;
          hellotheme.secundary = Colors.black;
          hellotheme.background = Color.fromARGB(255, 128, 0, 126);
          hellotheme.background1 = Color.fromARGB(125, 154, 8, 152);
        });
      }
      setState(() {
        isVisible = true;
      });
    }
  }
}
