import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hellogram/domain/blocs/auth/auth_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/screens/login/started_page.dart';
import 'package:hellogram/ui/screens/profile/account_profile_page.dart';
import 'package:hellogram/ui/screens/profile/change_password_page.dart';
import 'package:hellogram/ui/screens/profile/privacy_profile_page.dart';
import 'package:hellogram/ui/screens/profile/theme_profile_page.dart';
import 'package:hellogram/ui/screens/profile/widgets/item_profile.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class SettingProfilePage extends StatelessWidget {
  const SettingProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const TextCustom(
            text: 'Configuración', fontSize: 19, fontWeight: FontWeight.w500),
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [
            const SizedBox(height: 15.0),
            ItemProfile(
                text: 'Follow and invite a friend',
                icon: Icons.person_add_alt,
                onPressed: () {}),
            ItemProfile(
                text: 'Notifications',
                icon: Icons.notifications_none_rounded,
                onPressed: () {}),
            ItemProfile(
                text: 'Privacy',
                icon: Icons.lock_outline_rounded,
                onPressed: () => Navigator.push(
                    context, routeSlide(page: const PrivacyProgilePage()))),
            ItemProfile(
                text: 'Security',
                icon: Icons.security_outlined,
                onPressed: () => Navigator.push(
                    context, routeSlide(page: const ChangePasswordPage()))),
            ItemProfile(
                text: 'Account',
                icon: Icons.account_circle_outlined,
                onPressed: () => Navigator.push(
                    context, routeSlide(page: const AccountProfilePage()))),
            ItemProfile(
                text: 'Help',
                icon: Icons.help_outline_rounded,
                onPressed: () {}),
            ItemProfile(
                text: 'About',
                icon: Icons.info_outline_rounded,
                onPressed: () {}),
            ItemProfile(
                text: 'Themes',
                icon: Icons.palette_outlined,
                onPressed: () => Navigator.push(
                    context, routeSlide(page: const ThemeProfilePage()))),
            const SizedBox(height: 20.0),
            Row(
              children: const [
                Icon(Icons.copyright_outlined),
                SizedBox(width: 5.0),
                TextCustom(
                    text: 'Hellogram',
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ],
            ),
            const SizedBox(height: 30.0),
            const TextCustom(
                text: 'Sessions', fontSize: 17, fontWeight: FontWeight.w500),
            const SizedBox(height: 10.0),
            ItemProfile(
                text: 'Add or change account',
                icon: Icons.add,
                colorText: Color.fromARGB(255, 128, 0, 126),
                onPressed: () {}),
            ItemProfile(
                text: 'log out ${userBloc.state.user!.username}',
                icon: Icons.logout_rounded,
                colorText: Color.fromARGB(255, 128, 0, 126),
                onPressed: () {
                  authBloc.add(OnLogOutEvent());
                  userBloc.add(OnLogOutUser());
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const StartedPage()), (_) => false);
                }),
          ],
        ),
      ),
    );
  }
}
