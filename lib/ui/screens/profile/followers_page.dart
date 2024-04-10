import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/models/response/response_followers.dart';
import 'package:hellogram/domain/services/user_services.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/helpers/error_message.dart';
import 'package:hellogram/ui/helpers/modal_loading.dart';
import 'package:hellogram/ui/screens/profile/profile_another_user_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingFollowersUser) {
          modalLoading(context, 'Cargando...');
        } else if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessFollowersUser) {
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        appBar: AppBar(
          backgroundColor: hellotheme.primary,
          title: TextCustom(
              color: hellotheme.secundary,
              text: 'Followers',
              letterSpacing: .8,
              fontSize: 19),
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
          child: FutureBuilder<List<Follower>>(
            future: userService.getAllFollowers(),
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
                  : _ListFollowers(follow: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _ListFollowers extends StatelessWidget {
  final List<Follower> follow;

  const _ListFollowers({Key? key, required this.follow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: follow.length,
        itemBuilder: (context, i) {
          return InkWell(
            borderRadius: BorderRadius.circular(10.0),
            splashColor: Colors.white,
            onTap: () => Navigator.push(
                context,
                routeSlide(
                    page: ProfileAnotherUserPage(idUser: follow[i].uidUser))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.amber,
                        backgroundImage: NetworkImage(
                            Environment.baseUrl + follow[i].avatar),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextCustom(text: follow[i].username, fontSize: 16),
                          TextCustom(
                              text: follow[i].fullname,
                              color: Colors.grey,
                              fontSize: 15)
                        ],
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(50.0)),
                    elevation: 0,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        splashColor: Colors.blue[50],
                        onTap: () => userBloc
                            .add(OnDeletefollowersEvent(follow[i].uidUser)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 17.0, vertical: 6.0),
                          child: TextCustom(
                              color: Colors.black,
                              text: 'Eliminate',
                              fontSize: 16),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
