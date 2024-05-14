import 'package:flutter/material.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class ThemeProfilePage extends StatelessWidget {
  const ThemeProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hellotheme.primary,
      appBar: AppBar(
        backgroundColor: hellotheme.primary,
        title:
            const TextCustom(text: 'Change Theme', fontWeight: FontWeight.w500),
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new_rounded, color: hellotheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  hellotheme.primary = Color.fromARGB(255, 172, 226, 225);
                  hellotheme.background1 = Color.fromARGB(255, 65, 201, 226);
                  hellotheme.background = Color.fromARGB(255, 0, 141, 218);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(
                      text: 'Sky blue',
                      color: hellotheme.secundary,
                    ),
                    Icon(Icons.radio_button_checked,
                        color: hellotheme.background)
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  hellotheme.primary = Color.fromARGB(255, 255, 192, 217);
                  hellotheme.background1 = Color.fromARGB(255, 255, 144, 188);
                  hellotheme.background = Color.fromARGB(255, 255, 192, 217);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(
                      text: 'PINK',
                      color: hellotheme.secundary,
                    ),
                    Icon(Icons.radio_button_checked,
                        color: hellotheme.background)
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TextCustom(text: 'System'),
                  Icon(Icons.radio_button_off_rounded)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
