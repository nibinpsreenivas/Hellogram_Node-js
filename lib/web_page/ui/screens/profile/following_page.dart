import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/models/response/response_followings.dart';
import 'package:hellogram/domain/services/user_services.dart';
import 'package:hellogram/web_page/ui/helpers/animation_route.dart';
import 'package:hellogram/web_page/ui/helpers/error_message.dart';
import 'package:hellogram/web_page/ui/helpers/modal_loading.dart';
import 'package:hellogram/web_page/ui/screens/profile/profile_another_user_page.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingFollowingUser) {
          modalLoading(context, 'Charging...');
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessFollowingUser) {
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        appBar: AppBar(
          backgroundColor: hellotheme.primary,
          title: const TextCustom(
              text: 'Friends', letterSpacing: .8, fontSize: 19,textAlign: TextAlign.center,),
              centerTitle: true,
          elevation: 0,
    
          leading: IconButton(
              splashRadius: 20,
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: hellotheme.secundary,
              )),
        ),
        body: SafeArea(
          child: FutureBuilder<List<Following>>(
            future: userService.getAllFollowing(),
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
                  : _ListFollowings(follow: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _ListFollowings extends StatelessWidget {
  final List<Following> follow;

  const _ListFollowings({Key? key, required this.follow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: follow.length,
      itemBuilder: (context, i) {
        return InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: Colors.grey[300],
          onTap: () => Navigator.push(
            context,
            routeSlide(
              page: ProfileAnotherUserPage(idUser: follow[i].uidUser),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 250.0), 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row( 
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 250.0), 
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.amber,
                            backgroundImage: NetworkImage(
                              Environment.baseUrl + follow[i].avatar,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextCustom(
                                color: hellotheme.secundary,
                                text: follow[i].username,
                                fontSize: 16,
                              ),
                              TextCustom(
                                text: follow[i].fullname,
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row( 
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 250.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          splashColor: Colors.blue[50],
                          onTap: () => userBloc
                              .add(OnDeletefollowingEvent(follow[i].uidUser)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 17.0, vertical: 6.0),
                            child: TextCustom(
                              color: Colors.black,
                              text: 'Unfollow',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
