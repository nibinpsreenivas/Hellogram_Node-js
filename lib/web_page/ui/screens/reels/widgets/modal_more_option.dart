import 'package:flutter/material.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

modalOptionsReel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: Colors.white,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * .36,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
            const SizedBox(height: 10.0),
            ItemModal(
              icon: Icons.report_gmailerrorred_outlined,
              text: 'report',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ItemModal(
              icon: Icons.no_accounts_rounded,
              text: 'I am not interested',
              onPressed: () {},
            ),
            ItemModal(
              icon: Icons.copy_all_rounded,
              text: 'Copy Link',
              onPressed: () {},
            ),
            ItemModal(
              icon: Icons.share_outlined,
              text: 'share',
              onPressed: () {},
            ),
            ItemModal(
              icon: Icons.save_outlined,
              text: 'keep',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
