import 'package:flutter/material.dart';
import 'package:hellogram/web_page/ui/helpers/animation_route.dart';
import 'package:hellogram/web_page/ui/qrcode/qrcode.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

void modalOptionsAnotherUser(BuildContext context) {
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
    builder: (context) => Container(
      height: 237,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      decoration: BoxDecoration(
          color: hellotheme.secundary,
          borderRadius: BorderRadius.circular(25.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(height: 5, width: 40, color: Colors.grey[300]),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      foregroundColor: Colors.grey),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: const [
                          Icon(Icons.report_gmailerrorred_rounded,
                              color: Colors.red),
                          SizedBox(width: 10.0),
                          TextCustom(
                              text: 'report', fontSize: 17, color: Colors.red),
                        ],
                      ))),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      foregroundColor: Colors.grey),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.block_outlined, color: Colors.red),
                          SizedBox(width: 10.0),
                          TextCustom(
                            text: 'Block',
                            fontSize: 17,
                            color: Colors.red,
                          ),
                        ],
                      ))),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context, routeSlide(page:qr_page()));
                  },
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      foregroundColor: Colors.grey),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.qr_code, color: hellotheme.background),
                          SizedBox(width: 10.0),
                          TextCustom(
                            text: 'Profile QR CODE',
                            fontSize: 17,
                            color: hellotheme.background,
                          ),
                        ],
                      ))),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      foregroundColor: Colors.grey),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined,
                              color: hellotheme.background),
                          SizedBox(width: 10.0),
                          TextCustom(
                            text: 'Share this profile',
                            fontSize: 17,
                            color: hellotheme.background,
                          ),
                        ],
                      ))),
            ),
          ],
        ),
      ),
    ),
  );
}
