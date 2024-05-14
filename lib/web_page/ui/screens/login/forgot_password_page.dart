import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.clear();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: hellotheme.primary,
      appBar: AppBar(
        backgroundColor: hellotheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: hellotheme.secundary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 400.0, vertical: 150.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: 'Recover your account!',
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: hellotheme.background,
                    ),
                    const SizedBox(height: 30.0),
                    const TextCustom(
                      text: 'Enter your email to recover your account.',
                      fontSize: 17,
                      letterSpacing: 1.0,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: TextFieldFrave(
                        controller: emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    BtnFrave(
                      text: 'Find account',
                      width: 300,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2.0),
              SizedBox(
                height: 400.0,
                width: 400.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 100),
                  child: SvgPicture.asset(
                    'assets/svg/undraw_modern_design_re_dlp8.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
