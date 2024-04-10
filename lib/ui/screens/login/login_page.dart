import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellogram/domain/blocs/auth/auth_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/ui/helpers/helpers.dart';
import 'package:hellogram/ui/screens/emotion/emotion.dart';
import 'package:hellogram/ui/screens/home/home_page.dart';
import 'package:hellogram/ui/screens/home/home_page_emotion.dart';
import 'package:hellogram/ui/screens/login/forgot_password_page.dart';
import 'package:hellogram/ui/screens/login/verify_email_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    passwordController.clear();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthentication) {
          modalLoading(context, 'Verifying...');
        } else if (state is FailureAuthentication) {
          Navigator.pop(context);

          if (state.error == 'Please check your email.....') {
            Navigator.push(
                context,
                routeSlide(
                    page: VerifyEmailPage(email: emailController.text.trim())));
          }

          errorMessageSnack(context, state.error);
        } else if (state is SuccessAuthentication) {
          userBloc.add(OnGetUserAuthenticationEvent());
          Navigator.pop(context);
          if (Emotion.emotion == "sad" || Emotion.emotion == "Angry") {
            Navigator.pushAndRemoveUntil(
                context, routeSlide(page: const HomePagee()), (_) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context, routeSlide(page: const HomePage()), (_) => false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Form(
                key: _keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150.0),
                    const SizedBox(height: 10.0),

                    //SVG image
                    Center(
                      child: Image.asset(
                        "assets/img/hello.png",
                        color: hellotheme.secundary,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 64),
                    TextFieldFrave(
                      controller: emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validatedEmail,
                    ),
                    const SizedBox(height: 24),
                    TextFieldFrave(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 24),
                    BtnFrave(
                      text: 'Log in',
                      colorText: hellotheme.primary,
                      width: size.width,
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          authBloc.add(OnLoginEvent(emailController.text.trim(),
                              passwordController.text.trim()));
                        }
                      },
                    ),
                    const SizedBox(height: 130.0),
                    Center(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  routeSlide(page: const ForgotPasswordPage()));
                            },
                            child: TextCustom(
                              text: 'I forgot my password?',
                              color: hellotheme.secundary,
                            )))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
