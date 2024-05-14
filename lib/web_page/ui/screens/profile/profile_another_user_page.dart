import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/domain/models/response/response_user_search.dart';
import 'package:hellogram/domain/services/user_services.dart';
import 'package:hellogram/web_page/ui/helpers/animation_route.dart';
import 'package:hellogram/web_page/ui/helpers/error_message.dart';
import 'package:hellogram/web_page/ui/helpers/modal_loading.dart';
import 'package:hellogram/web_page/ui/helpers/modal_options_another_user.dart';
import 'package:hellogram/web_page/ui/screens/messages/chat_message_page.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class ProfileAnotherUserPage extends StatefulWidget {
  final String idUser;

  const ProfileAnotherUserPage({Key? key, required this.idUser})
      : super(key: key);

  @override
  State<ProfileAnotherUserPage> createState() => _ProfileAnotherUserPageState();
}

class _ProfileAnotherUserPageState extends State<ProfileAnotherUserPage> {
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
        body: SafeArea(
          child: FutureBuilder<ResponseUserSearch>(
            future: userService.getAnotherUserById(widget.idUser),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const _LoadingDataUser()
                  : _BodyUser(responseUserSearch: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _BodyUser extends StatelessWidget {
  final ResponseUserSearch responseUserSearch;

  const _BodyUser({Key? key, required this.responseUserSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _CoverAndProfile(user: responseUserSearch.anotherUser),
        const SizedBox(height: 10.0),
        _UsernameAndDescription(user: responseUserSearch.anotherUser),
        const SizedBox(height: 30.0),
        _PostAndFollowingAndFollowers(analytics: responseUserSearch.analytics),
        const SizedBox(height: 30.0),
        _BtnFollowAndMessage(
          isFriend: responseUserSearch.isFriend,
          uidUser: responseUserSearch.anotherUser.uid,
          isPendingFollowers: responseUserSearch.isPendingFollowers,
          username: responseUserSearch.anotherUser.username,
          avatar: responseUserSearch.anotherUser.image,
        ),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 46,
          child: Column(
            children: [
              const Icon(Icons.grid_on_rounded, size: 30),
              const SizedBox(height: 5.0),
              Container(
                height: 1,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        _ListFotosAnotherProfile(
          posts: responseUserSearch.postsUser,
          isPrivate: responseUserSearch.anotherUser.isPrivate,
          isFriend: responseUserSearch.isFriend,
        ),
      ],
    );
  }
}

class _ListFotosAnotherProfile extends StatelessWidget {
  final List<PostsUser> posts;
  final int isPrivate;
  final int isFriend;

  const _ListFotosAnotherProfile(
      {Key? key,
      required this.posts,
      required this.isPrivate,
      required this.isFriend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: isPrivate == 0 || isPrivate == 1 && isFriend == 1
            ? GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisExtent: 170),
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  final List<String> listImages = posts[i].images.split(',');

                  return InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  Environment.baseUrl + listImages.first))),
                    ),
                  );
                },
              )
            : SizedBox(
                height: 100,
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 40),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        TextCustom(
                            text: 'This account is private',
                            fontWeight: FontWeight.w500),
                        TextCustom(
                            text: 'Follow this account to see their photos.',
                            color: Colors.grey,
                            fontSize: 16),
                      ],
                    )
                  ],
                ),
              ));
  }
}

class _BtnFollowAndMessage extends StatelessWidget {
  final int isFriend;
  final int isPendingFollowers;
  final String uidUser;
  final String username;
  final String avatar;

  const _BtnFollowAndMessage({
    Key? key,
    required this.isFriend,
    required this.uidUser,
    required this.isPendingFollowers,
    required this.username,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 43,
          width: size.width * 0.15, // Custom width for the button
          decoration: BoxDecoration(
            color: isFriend == 1 || isPendingFollowers == 1
                ? hellotheme.secundary
                : hellotheme.background,
            border: Border.all(
              color: isFriend == 1 || isPendingFollowers == 1
                  ? Colors.grey
                  : Colors.white,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: isPendingFollowers == 0
              ? TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: TextCustom(
                    text: isFriend == 1 ? 'Following' : 'FOLLOW',
                    fontSize: 20,
                    color: isFriend == 1
                        ? hellotheme.primary
                        : hellotheme.secundary,
                  ),
                  onPressed: () {
                    if (isFriend == 1) {
                      userBloc.add(OnDeletefollowingEvent(uidUser));
                    } else {
                      userBloc.add(OnAddNewFollowingEvent(uidUser));
                    }
                  },
                )
              : TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const TextCustom(
                    text: 'Earring',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
        ),
        SizedBox(width: 5), // Custom space between buttons
        Container(
          height: 43,
          width: size.width * 0.15, // Custom width for the button
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: TextCustom(
              color: hellotheme.secundary,
              text: 'Message',
              fontSize: 20,
            ),
            onPressed: () => Navigator.push(
              context,
              routeFade(
                page: ChatMessagesPage(
                  uidUserTarget: uidUser,
                  usernameTarget: username,
                  avatarTarget: avatar,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PostAndFollowingAndFollowers extends StatelessWidget {
  final Analytics analytics;
  const _PostAndFollowingAndFollowers({Key? key, required this.analytics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      width: size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(), // Add Spacer to push Post section to the right
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0), // Keep padding for Following

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSpacer(width: 10),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (_, state) => state.postsUser?.friends != null
                            ? TextCustom(
                                color: hellotheme.secundary,
                                text: state.postsUser!.friends.toString(),
                                fontSize: 22,
                                fontWeight: FontWeight.w500)
                            : const TextCustom(text: ''),
                      ),
                      const TextCustom(
                        text: 'Following',
                        fontSize: 17,
                        color: Colors.grey,
                        letterSpacing: .7,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0), // Keep padding for Followers

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (_, state) =>
                            state.postsUser?.followers != null
                                ? TextCustom(
                                    color: hellotheme.secundary,
                                    text: state.postsUser!.followers.toString(),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500)
                                : const TextCustom(text: '0'),
                      ),
                      const TextCustom(
                        text: 'Followers',
                        fontSize: 17,
                        color: Colors.grey,
                        letterSpacing: .7,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(), // Add Spacer to push Followers section to the left
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0), // Add padding between the sections
            child: Row(
              children: [
                Spacer(
                    flex:
                        2), // Add Spacer to create space between Post and Following
                Expanded(
                  flex: 5, // Adjust the flex value as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0), // Keep padding for Post
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<UserBloc, UserState>(
                          builder: (_, state) =>
                              state.postsUser?.posters != null
                                  ? TextCustom(
                                      color: hellotheme.secundary,
                                      text: state.postsUser!.posters.toString(),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)
                                  : const TextCustom(text: '0'),
                        ),
                        const TextCustom(
                          text: 'Post',
                          fontSize: 17,
                          color: Colors.grey,
                          letterSpacing: .7,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                    flex:
                        2), // Add Spacer to create space between Following and Followers
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSpace extends StatelessWidget {
  const _CustomSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Spacer();
  }
}

class _UsernameAndDescription extends StatelessWidget {
  final AnotherUser user;

  const _UsernameAndDescription({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: BlocBuilder<UserBloc, UserState>(
          builder: (_, state) {
            if (user.username != null) {
              if (state.user!.username != '') {
                // Call setState here when condition is true
                hellotheme.username = user.username;
              }
              return TextCustom(
                color: hellotheme.secundary,
                text: user.username,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        )),
        const SizedBox(height: 5.0),
        Center(
            child: TextCustom(
          color: hellotheme.secundary,
          text: user.description,
          fontSize: 17,
        )),
      ],
    );
  }
}

class _CoverAndProfile extends StatelessWidget {
  final AnotherUser user;

  const _CoverAndProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 200,
      width: size.width,
      child: Stack(
        children: [
          SizedBox(
              height: 170,
              width: size.width,
              child: user.cover != ''
                  ? Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(Environment.baseUrl + user.cover))
                  : Container(
                      height: 170,
                      width: size.width,
                      color: Colors.transparent,
                    )),
          Positioned(
            bottom: 28,
            child: Container(
              height: 20,
              width: size.width,
              decoration: BoxDecoration(
                  color: hellotheme.primary,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0))),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: size.width,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(Environment.baseUrl + user.image)),
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: IconButton(
                onPressed: () => modalOptionsAnotherUser(context),
                icon: Icon(Icons.dashboard_customize_outlined,
                    color: hellotheme.secundary),
              )),
          Positioned(
              child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: hellotheme.secundary),
          )),
        ],
      ),
    );
  }
}

class _LoadingDataUser extends StatelessWidget {
  const _LoadingDataUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          ShimmerFrave(),
          SizedBox(height: 10.0),
          ShimmerFrave(),
          SizedBox(height: 10.0),
          ShimmerFrave(),
          SizedBox(height: 10.0),
          ShimmerFrave(),
        ],
      ),
    );
  }
}
