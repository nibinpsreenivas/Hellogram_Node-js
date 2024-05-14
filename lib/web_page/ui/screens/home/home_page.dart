import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/web_page/ui/screens/emotion/emotion.dart';
import 'package:hellogram/web_page/ui/screens/home/home_page_emotion.dart';
import 'package:hellogram/web_page/ui/screens/profile/profile_page.dart';
import 'package:hellogram/web_page/ui/screens/reels/reel_home_screen.dart';
import 'package:hellogram/web_page/ui/screens/searchs/search_page.dart';
import 'package:hellogram/web_page/ui/screens/addPost/add_post_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hellogram/domain/models/response/response_stories.dart';
import 'package:hellogram/domain/services/story_services.dart';
import 'package:hellogram/web_page/ui/helpers/helpers.dart';
import 'package:hellogram/web_page/ui/screens/Story/add_story_page.dart';
import 'package:hellogram/web_page/ui/screens/Story/view_story_page.dart';
import 'package:hellogram/web_page/ui/screens/comments/comments_post_page.dart';
import 'package:hellogram/web_page/ui/screens/messages/list_messages_page.dart';
import 'package:hellogram/web_page/ui/screens/notifications/notifications_page.dart';
import 'package:hellogram/domain/models/response/response_post.dart';
import 'package:hellogram/domain/services/post_services.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';
import 'package:hellogram/domain/blocs/post/post_bloc.dart';
import 'package:side_navigation/side_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is LoadingSavePost || state is LoadingPost) {
          modalLoadingShort(context);
        } else if (state is FailurePost) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessPost) {
          Navigator.pop(context);
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        appBar: AppBar(
          backgroundColor: hellotheme.primary,
          title: Image.asset(
            "assets/img/hello.png",
            color: hellotheme.secundary,
            height: 40,
          ),
          elevation: 0,
          actions: [
            _ItemButtom(
              i: 1,
              index: 1,
              isIcon: false,
              iconString: 'assets/svg/home_icon.svg',
              isReel: false,
              onPressed: () {
                if (Emotion.emotion == "sad" || Emotion.emotion == "Angry") {
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const HomePagee()), (_) => false);
                } else {
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const HomePage()), (_) => false);
                }
              },
            ),
            // Custom spacing between first 2 icons (increased width)
            _ItemButtom(
              i: 2,
              index: 2,
              icon: Icons.search,
              isReel: false,
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, routeSlide(page: const SearchPage()), (_) => false),
            ),

            _ItemButtom(
              i: 3,
              index: 3,
              isIcon: false,
              isReel: true,
              iconString: 'assets/svg/movie_reel.svg',
              onPressed: () => Navigator.push(
                  context, routeSlide(page: const ReelHomeScreen())),
            ),

            _ItemButtom(
              i: 4,
              index: 4,
              icon: Icons.favorite_border_rounded,
              isReel: false,
              onPressed: () => Navigator.pushAndRemoveUntil(context,
                  routeSlide(page: const NotificationsPage()), (_) => false),
            ),

            _ItemProfile(),
            IconButton(
                color: hellotheme.secundary,
                splashRadius: 20,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      routeSlide(page: const AddPostPage()), (_) => false);
                },
                icon: SvgPicture.asset('assets/svg/add_rounded.svg',
                    color: hellotheme.secundary, height: 32)),
            IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.pushAndRemoveUntil(context,
                    routeSlide(page: const NotificationsPage()), (_) => false),
                icon: SvgPicture.asset('assets/svg/notification-icon.svg',
                    color: hellotheme.secundary, height: 26)),
            IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.push(
                    context, routeSlide(page: const ListMessagesPage())),
                icon: SvgPicture.asset('assets/svg/chat-icon.svg',
                    color: hellotheme.secundary, height: 24)),
          ],
        ),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const _ListHistories(),
              const SizedBox(height: 5.0),
              FutureBuilder<List<Post>>(
                future: postService.getAllPostHome(),
                builder: (_, snapshot) {
                  if (snapshot.data != null && snapshot.data!.isEmpty) {
                    return _ListWithoutPosts();
                  }
                  print("helol ooooooooo${snapshot.data}");
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, i) =>
                              _ListViewPosts(posts: snapshot.data![i]),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListHistories extends StatelessWidget {
  const _ListHistories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 200.0),
      height: 96,
      width: size.width,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          BlocBuilder<UserBloc, UserState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) => state.user != null
                  ? InkWell(
                      onTap: () => Navigator.push(
                          context, routeSlide(page: const AddStoryPage())),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  Environment.baseUrl +
                                      state.user!.image.toString()),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextCustom(
                            text: state.user!.fullname,
                            fontSize: 8,
                          )
                        ],
                      ),
                    )
                  : const CircleAvatar()),
          const SizedBox(width: 10.0),
          SizedBox(
            height: 90,
            width: size.width,
            child: FutureBuilder<List<StoryHome>>(
              future: storyServices.getAllStoriesHome(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const ShimmerFrave()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.push(
                                context,
                                routeFade(
                                    page: ViewStoryPage(
                                        storyHome: snapshot.data![i]))),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            colors: [
                                              Colors.pink,
                                              Colors.amber
                                            ])),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(Environment
                                                      .baseUrl +
                                                  snapshot.data![i].avatar))),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  TextCustom(
                                      text: snapshot.data![i].username,
                                      fontSize: 15)
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ListViewPosts extends StatelessWidget {
  final Post posts;

  const _ListViewPosts({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final postBloc = BlocProvider.of<PostBloc>(context);

    final List<String> listImages = posts.images.split(',');
    final time = timeago.format(posts.createdAt, locale: 'en');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: 550,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: hellotheme.background.withOpacity(1), // Purple glow color
              spreadRadius: 1,
              blurRadius: 10, // Increase the blur radius for a smoother glow
              offset: const Offset(0, 0),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [hellotheme.primary, Colors.grey[900]!],
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CarouselSlider.builder(
                itemCount: listImages.length,
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  height: 550,
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: false,
                ),
                itemBuilder: (context, i, realIndex) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(Environment.baseUrl + listImages[i]),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundImage: NetworkImage(
                                    Environment.baseUrl + posts.avatar),
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    text: posts.username,
                                    color: hellotheme.secundary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextCustom(
                                    text: time,
                                    fontSize: 15,
                                    color: hellotheme.secundary,
                                  ),
                                ],
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert_rounded,
                                color: hellotheme.secundary, size: 25),
                          )
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      height: 45,
                      width: size.width * .9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            color: hellotheme.primary.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => postBloc.add(
                                            OnLikeOrUnLikePost(
                                                posts.postUid, posts.personUid),
                                          ),
                                          child: posts.isLike == 1
                                              ? const Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red)
                                              : Icon(
                                                  Icons
                                                      .favorite_outline_rounded,
                                                  color: hellotheme.secundary),
                                        ),
                                        const SizedBox(width: 8.0),
                                        InkWell(
                                          onTap: () {},
                                          child: TextCustom(
                                            text: posts.countLikes.toString(),
                                            fontSize: 16,
                                            color: hellotheme.secundary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20.0),
                                    TextButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        routeFade(
                                            page: CommentsPostPage(
                                                uidPost: posts.postUid)),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/message-icon.svg'),
                                          const SizedBox(width: 5.0),
                                          TextCustom(
                                            text: posts.countComment.toString(),
                                            fontSize: 16,
                                            color: hellotheme.secundary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                          'assets/svg/send-icon.svg',
                                          height: 24),
                                    ),
                                    IconButton(
                                      onPressed: () => postBloc
                                          .add(OnSavePostByUser(posts.postUid)),
                                      icon: Icon(Icons.bookmark_border_rounded,
                                          size: 27,
                                          color: hellotheme.secundary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListWithoutPosts extends StatelessWidget {
  final List<String> svgPosts = [
    'assets/svg/without-posts-home.svg',
    'assets/svg/without-posts-home.svg',
    'assets/svg/mobile-new-posts.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          padding: const EdgeInsets.all(10.0),
          height: 350,
          width: size.width,
          // color: Colors.amber,
          child: SvgPicture.asset(
            svgPosts[index],
            height: 15,
            color: hellotheme.primary,
          ),
        ),
      ),
    );
  }
}

class _ItemProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushAndRemoveUntil(
          context, routeSlide(page: const ProfilePage()), (_) => false),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (_, state) => state.user?.image != null
            ? CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage(Environment.baseUrl + state.user!.image))
            : CircleAvatar(
                radius: 15,
                backgroundColor: hellotheme.background,
                child: CircularProgressIndicator(
                    color: hellotheme.secundary, strokeWidth: 2)),
      ),
    );
  }
}

class _ItemButtom extends StatelessWidget {
  final int i;
  final int index;
  final bool isIcon;
  final IconData? icon;
  final String? iconString;
  final Function() onPressed;
  final bool isReel;

  const _ItemButtom({
    Key? key,
    required this.i,
    required this.index,
    required this.onPressed,
    this.icon,
    this.iconString,
    this.isIcon = true,
    this.isReel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isemotion() {
      if (Emotion.emotion == "sad" || Emotion.emotion == "Angry") {
        return true;
      }
      return false;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        child: (isIcon)
            ? Icon(icon,
                color:
                    (i == index) ? hellotheme.background : hellotheme.secundary,
                size: 28)
            : SvgPicture.asset(
                iconString!,
                height: 25,
                color: hellotheme.secundary,
              ),
      ),
    );
  }
}
