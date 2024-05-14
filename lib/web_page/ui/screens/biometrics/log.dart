import 'package:flutter/material.dart';
import 'package:hellogram/domain/services/auth.dart';
import 'package:hellogram/web_page/ui/screens/login/login_page.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  @override
  void initState() {
    super.initState();
    authenticateUserOnStart();
  }

  void authenticateUserOnStart() async {
    bool isAuthenticated = await AuthService.authenticateUser();
    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 171, 199),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: size.width * 0.3),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
