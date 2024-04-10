import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/ui/helpers/helpers.dart';
import 'package:hellogram/ui/screens/login/login_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController fullNameController;
  late TextEditingController userController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    userController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context, 'Charging...');
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(context, 'Registered user',
              onPressed: () => Navigator.pushAndRemoveUntil(context,
                  routeSlide(page: const LoginPage()), (route) => false));
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: Scaffold(
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
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: Form(
                key: _keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: 'Hello!',
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: hellotheme.background,
                    ),
                    const SizedBox(height: 10.0),
                    const TextCustom(
                      text: 'Create a new account.',
                      fontSize: 17,
                      letterSpacing: 1.0,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldFrave(
                      controller: fullNameController,
                      hintText: 'Full name',
                      validator:
                          RequiredValidator(errorText: 'The name is required'),
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldFrave(
                      controller: userController,
                      hintText: 'User',
                      validator:
                          RequiredValidator(errorText: 'The user is required'),
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldFrave(
                      controller: emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: validatedEmail,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldFrave(
                      controller: passwordController,
                      hintText: 'Password',
                      isPassword: true,
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 60.0),
                    const TextCustom(
                      text:
                          'By registering, you agree to the terms of service and privacy policies.',
                      fontSize: 15,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20.0),
                    BtnFrave(
                        text: 'Register',
                        width: size.width,
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            userBloc.add(OnRegisterUserEvent(
                                fullNameController.text.trim(),
                                userController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim()));
                          }
                        }),
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
