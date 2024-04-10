import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextCustom(
                text: 'Recover your account!',
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: Color.fromARGB(255, 128, 0, 126),
              ),
              const SizedBox(height: 10.0),
              const TextCustom(
                text: 'Enter your email to recover your account.',
                fontSize: 17,
                letterSpacing: 1.0,
                maxLines: 2,
              ),
              SizedBox(
                height: 300,
                width: size.width,
                child: SvgPicture.asset(
                    'assets/svg/undraw_modern_design_re_dlp8.svg'),
              ),
              const SizedBox(height: 10.0),
              TextFieldFrave(
                controller: emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10.0),
              BtnFrave(
                text: 'Find account',
                width: size.width,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
