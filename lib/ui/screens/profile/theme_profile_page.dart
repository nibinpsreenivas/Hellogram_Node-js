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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(text: 'Day'),
                  Icon(Icons.radio_button_checked, color: hellotheme.background)
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TextCustom(text: 'Evening'),
                  Icon(Icons.radio_button_off_rounded)
                ],
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
