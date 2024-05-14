import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/domain/blocs/auth/auth_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/services/auth.dart';
import 'package:hellogram/web_page/ui/helpers/helpers.dart';
import 'package:hellogram/web_page/ui/screens/emotion/emotion.dart';
import 'package:hellogram/web_page/ui/screens/home/adminhome.dart';
import 'package:hellogram/web_page/ui/screens/home/home_page.dart';
import 'package:hellogram/web_page/ui/screens/home/userad.dart';
import 'package:hellogram/web_page/ui/screens/home/home_page_emotion.dart';
import 'package:hellogram/web_page/ui/screens/login/login_page.dart';
import 'package:hellogram/web_page/ui/screens/login/started_page.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: hellotheme.primary,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SizedBox(
            height: 200,
            width: 150,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      'assets/img/hello.png',
                      color: hellotheme.secundary,
                      height: 100,
                      width: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextCustom(text: 'LOADING...', color: hellotheme.secundary),
              ],
            ),
          ),
        ),
      ),
      //),
    );
  }
}
