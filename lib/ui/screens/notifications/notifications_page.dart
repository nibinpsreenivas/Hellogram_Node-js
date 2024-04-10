import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/models/response/response_notifications.dart';
import 'package:hellogram/domain/services/notifications_services.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/helpers/error_message.dart';
import 'package:hellogram/ui/helpers/modal_loading.dart';
import 'package:hellogram/ui/screens/emotion/emotion.dart';
import 'package:hellogram/ui/screens/home/home_page_emotion.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/ui/screens/home/home_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context, 'Charging...');
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessUserState) {
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        appBar: AppBar(
          backgroundColor: hellotheme.primary,
          title: const TextCustom(
              text: 'Activity',
              fontWeight: FontWeight.w500,
              letterSpacing: .9,
              fontSize: 19),
          elevation: 0,
          leading: IconButton(
              splashRadius: 20,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (Emotion.emotion == "sad" || Emotion.emotion == "Angry") {
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const HomePagee()), (_) => false);
                } else {
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const HomePage()), (_) => false);
                }
              }),
        ),
        body: SafeArea(
            child: FutureBuilder<List<Notificationsdb>>(
          future: notificationServices.getNotificationsByUser(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return SizedBox(
                        height: 90,
                        width: 80,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: hellotheme.background,
                                      backgroundImage: NetworkImage(
                                          Environment.baseUrl +
                                              snapshot.data![i].avatar),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                                color: hellotheme.secundary,
                                                text:
                                                    snapshot.data![i].follower,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                            TextCustom(
                                              color: hellotheme.secundary,
                                              text: timeago.format(
                                                  snapshot.data![i].createdAt,
                                                  locale: 'es_short'),
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (snapshot.data![i].typeNotification == '1')
                                  Card(
                                    color: hellotheme.background,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    elevation: 0,
                                    child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        splashColor: Colors.white54,
                                        onTap: () {
                                          userBloc.add(
                                              OnAcceptFollowerRequestEvent(
                                                  snapshot
                                                      .data![i].followersUid,
                                                  snapshot.data![i]
                                                      .uidNotification));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          child: TextCustom(
                                              text: 'Accept',
                                              fontSize: 16,
                                              color: hellotheme.secundary),
                                        )),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 5.0),
                            if (snapshot.data![i].typeNotification == '1')
                              TextCustom(
                                  text: 'I send you request ',
                                  fontSize: 16,
                                  color: hellotheme.secundary),
                            if (snapshot.data![i].typeNotification == '3')
                              TextCustom(
                                  text: 'I start following you',
                                  fontSize: 16,
                                  color: hellotheme.secundary),
                            if (snapshot.data![i].typeNotification == '2')
                              Row(
                                children: [
                                  TextCustom(
                                      text: 'hello',
                                      fontSize: 16,
                                      color: hellotheme.secundary),
                                  TextCustom(
                                      text: 'I like ',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: hellotheme.secundary),
                                  TextCustom(
                                      text: 'to your photo',
                                      fontSize: 16,
                                      color: hellotheme.secundary),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  );
          },
        )),
      ),
    );
  }
}
