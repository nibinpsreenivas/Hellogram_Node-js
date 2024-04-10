import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/blocs/chat/chat_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/models/response/response_list_messages.dart';
import 'package:hellogram/domain/services/chat_services.dart';

import 'package:hellogram/ui/screens/messages/widgets/chat_message.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class ChatMessagesPage extends StatefulWidget {
  final String uidUserTarget;
  final String usernameTarget;
  final String avatarTarget;

  const ChatMessagesPage(
      {Key? key,
      required this.uidUserTarget,
      required this.usernameTarget,
      required this.avatarTarget})
      : super(key: key);

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage>
    with TickerProviderStateMixin {
  late ChatBloc chatBloc;
  late TextEditingController _messageController;
  final _focusNode = FocusNode();

  List<ChatMessage> chatMessage = [];

  @override
  void initState() {
    super.initState();

    chatBloc = BlocProvider.of<ChatBloc>(context);

    chatBloc.initSocketChat();
    _historyMessages();

    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.clear();
    _messageController.dispose();
    for (ChatMessage message in chatMessage) {
      message.animationController.dispose();
    }

    chatBloc.disconnectSocket();
    chatBloc.disconnectSocketMessagePersonal();
    super.dispose();
  }

  _historyMessages() async {
    final List<ListMessage> list =
        await chatServices.listMessagesByUser(widget.uidUserTarget);

    final history = list.map((m) => ChatMessage(
        uidUser: m.sourceUid,
        message: m.message,
        time: m.createdAt,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 350))
          ..forward()));

    setState(() => chatMessage.insertAll(0, history));
  }

  _handleSubmit(String text) {
    _messageController.clear();
    _focusNode.requestFocus();
    final userBloc = BlocProvider.of<UserBloc>(context).state;

    if (userBloc.user != null) {
      final chat = ChatMessage(
        uidUser: userBloc.user!.uid,
        message: text,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 350)),
      );

      chatMessage.insert(0, chat);
      chat.animationController.forward();

      setState(() {});

      chatBloc.add(
          OnEmitMessageEvent(userBloc.user!.uid, widget.uidUserTarget, text));

      chatBloc.add(OnIsWrittingEvent(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hellotheme.primary,
      appBar: AppBar(
        backgroundColor: hellotheme.primary,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                    color: hellotheme.secundary,
                    text: widget.usernameTarget,
                    fontWeight: FontWeight.w500,
                    fontSize: 21),
              ],
            ),
          ],
        ),
        elevation: 0,
        leading: IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: hellotheme.secundary)),
        actions: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(Environment.baseUrl + widget.avatarTarget),
          ),
          const SizedBox(width: 10.0)
        ],
      ),
      body: Column(
        children: [
          Flexible(child: BlocBuilder<ChatBloc, ChatState>(
            builder: (_, state) {
              if (state.message != null) {
                final chatListen = ChatMessage(
                  uidUser: state.uidSource!,
                  message: state.message!,
                  animationController: AnimationController(
                      vsync: this, duration: const Duration(milliseconds: 350)),
                );

                chatMessage.insert(0, chatListen);
                chatListen.animationController.forward();
              }

              return ListView.builder(
                reverse: true,
                itemCount: chatMessage.length,
                itemBuilder: (_, i) => chatMessage[i],
              );
            },
          )),
          _textMessage()
        ],
      ),
    );
  }

  Widget _textMessage() {
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    return Container(
      color: Color.fromARGB(60, 255, 255, 255),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Flexible(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (_, state) => TextField(
                style: TextStyle(color: hellotheme.secundary),
                controller: _messageController,
                focusNode: _focusNode,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    chatBloc.add(OnIsWrittingEvent(true));
                  } else {
                    chatBloc.add(OnIsWrittingEvent(false));
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write a message',
                  hintStyle: GoogleFonts.roboto(fontSize: 17),
                ),
              ),
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (_, state) => TextButton(
              onLongPress: () async {
                if (_messageController.text.isNotEmpty) {
                  String _generatedResponse = '';

                  final apiKey = "AIzaSyDBWacb8lYJ1a_7oRsLAK2qaExKcT_VgY8";

                  final model =
                      GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
                  final content = [
                    Content.text(_messageController.text.trim())
                  ];
                  final response = await model.generateContent(content);
                  setState(() {
                    print(response.text!);
                    _generatedResponse = response.text!;
                  });

                  setState(() {
                    _messageController.text = _generatedResponse;
                  });
                }
              },
              onPressed: state.isWritting
                  ? () => _handleSubmit(_messageController.text.trim())
                  : null,
              child: const TextCustom(
                text: 'Send',
                color: Color.fromARGB(255, 128, 0, 126),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
