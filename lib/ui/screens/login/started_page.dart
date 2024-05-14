import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hellogram/ui/face/face_reg.dart';

import 'package:hellogram/ui/helpers/helpers.dart';
import 'package:hellogram/ui/screens/emotion/emotion.dart';
import 'package:hellogram/ui/screens/login/login_page.dart';
import 'package:hellogram/ui/screens/login/register_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({Key? key}) : super(key: key);

  @override
  State<StartedPage> createState() => _StartedPageState();
}

class _StartedPageState extends State<StartedPage> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  String mood = "";
  String face = "emotion";
  void sendRequest(filename) async {
    final response = await http.post(
      Uri.parse('http://192.168.236.74:5000/predict'),
      body: {'image': base64Encode(filename)},
    );
    final jsonData = jsonDecode(response.body);
    print(jsonData['emotion']);

    setState(() {
      face = jsonData['emotion'];
    });
    print(face);
  }

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

  void initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
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
                  const TextCustom(text: ' Social', fontSize: 17)
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                width: size.width,
                child: SvgPicture.asset(
                  'assets/svg/undraw_mobile_content_xvgr.svg',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SizedBox(
                height: 50,
                width: size.width,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        hellotheme.background,
                        hellotheme.background1,
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        hellotheme.background,
                        hellotheme.background1,
                      ])),
                  child: TextButton(
                    child: TextCustom(
                      text: 'Sign up',
                      fontSize: 20,
                      color: hellotheme.secundary,
                    ),
                    onPressed: () => Navigator.push(
                        context, routeSlide(page: FaceRegistrationScreen())),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void captureImage() async {
    try {
      // final _picker = ImagePicker();
      final XFile image = await _cameraController.takePicture();
      //XFile? image1 = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        isVisible = false;
        sendRequest(image.path);
        // Reset visibility when capturing a new image
      });
      extractData(image.path);
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
