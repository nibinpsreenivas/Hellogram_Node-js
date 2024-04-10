import 'package:flutter/material.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

void modalLoading(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Color.fromARGB(25, 128, 0, 126),
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: SizedBox(
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                TextCustom(
                    text: 'Hellogram ',
                    color: Color.fromARGB(255, 128, 0, 126),
                    fontWeight: FontWeight.w500),
                TextCustom(text: 'loading', fontWeight: FontWeight.w500),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const CircularProgressIndicator(
                    color: Color.fromARGB(255, 128, 0, 126)),
                const SizedBox(width: 15.0),
                TextCustom(text: text)
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
