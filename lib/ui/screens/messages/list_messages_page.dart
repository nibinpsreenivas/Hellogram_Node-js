import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/domain/models/response/response_list_chat.dart';
import 'package:hellogram/domain/services/chat_services.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/ui/screens/messages/chat_message_page.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class ListMessagesPage extends StatefulWidget {
  const ListMessagesPage({Key? key}) : super(key: key);

  @override
  State<ListMessagesPage> createState() => _ListMessagesPageState();
}

class _ListMessagesPageState extends State<ListMessagesPage> {
  String _decrypt(String ciphertext) {
    // Caesar Cipher with a fixed shift value of 3
    StringBuffer decryptedText = StringBuffer();

    for (int i = 0; i < ciphertext.length; i++) {
      int charCode = ciphertext.codeUnitAt(i);
      // Uppercase letters
      if (charCode >= 65 && charCode <= 90) {
        decryptedText
            .write(String.fromCharCode((charCode - 65 - 3 + 26) % 26 + 65));
      }
      // Lowercase letters
      else if (charCode >= 97 && charCode <= 122) {
        decryptedText
            .write(String.fromCharCode((charCode - 97 - 3 + 26) % 26 + 97));
      }
      // Other characters remain unchanged
      else {
        decryptedText.write(ciphertext[i]);
      }
    }

    return decryptedText.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hellotheme.primary,
      appBar: AppBar(
        backgroundColor: hellotheme.primary,
        title: const TextCustom(
            text: 'Messages',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: .8),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            splashRadius: 20,
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: hellotheme.secundary)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svg/new-message.svg',
                  color: hellotheme.secundary, height: 23))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey[300]!)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: hellotheme.secundary),
                      decoration: InputDecoration(
                        fillColor: hellotheme.secundary,
                        contentPadding: const EdgeInsets.only(left: 10.0),
                        hintText: 'Find a friend',
                        hintStyle:
                            GoogleFonts.roboto(letterSpacing: .8, fontSize: 17),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                  const SizedBox(width: 10.0)
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Flexible(
                child: FutureBuilder<List<ListChat>>(
              future: chatServices.getListChatByUser(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Column(
                        children: const [
                          ShimmerFrave(),
                          SizedBox(height: 10.0),
                          ShimmerFrave(),
                          SizedBox(height: 10.0),
                          ShimmerFrave(),
                        ],
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) => InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  routeFade(
                                      page: ChatMessagesPage(
                                    uidUserTarget: snapshot.data![i].targetUid,
                                    usernameTarget: snapshot.data![i].username,
                                    avatarTarget: snapshot.data![i].avatar,
                                  ))),
                              borderRadius: BorderRadius.circular(10.0),
                              child: Column(
                                children: [
                                  Container(
                                    color: Color.fromARGB(23, 128, 0, 126),
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    height: 80,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 27,
                                          backgroundImage: NetworkImage(
                                              Environment.baseUrl +
                                                  snapshot.data![i].avatar),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextCustom(
                                                  color: hellotheme.secundary,
                                                  text: snapshot
                                                      .data![i].username),
                                              const SizedBox(height: 5.0),
                                              TextCustom(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  text: _decrypt(snapshot
                                                      .data![i].lastMessage),
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        TextCustom(
                                            color: hellotheme.secundary,
                                            text: timeago.format(
                                                snapshot.data![i].updatedAt,
                                                locale: 'in_short'),
                                            fontSize: 15),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ));
              },
            )),
          ],
        ),
      ),
    );
  }
}
