import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/web_page/ui/helpers/access_permission.dart';
import 'package:hellogram/web_page/ui/helpers/animation_route.dart';
import 'package:hellogram/web_page/ui/helpers/error_message.dart';
import 'package:hellogram/web_page/ui/helpers/modal_loading.dart';
import 'package:hellogram/web_page/ui/helpers/modal_picture.dart';
import 'package:hellogram/web_page/ui/helpers/modal_profile_settings.dart';
import 'package:hellogram/web_page/ui/helpers/modal_success.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/models/response/response_post_profile.dart';
import 'package:hellogram/domain/models/response/response_post_saved.dart';
import 'package:hellogram/domain/services/post_services.dart';
import 'package:hellogram/web_page/ui/components/animted_toggle.dart';
import 'package:hellogram/web_page/ui/screens/profile/followers_page.dart';
import 'package:hellogram/web_page/ui/screens/profile/following_page.dart';
import 'package:hellogram/web_page/ui/screens/profile/list_photos_profile_page.dart';
import 'package:hellogram/web_page/ui/screens/profile/saved_posts_page.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadingUserState) {
          modalLoading(context, 'Updating image...');
        }
        if (state is SuccessUserState) {
          Navigator.pop(context);
          modalSuccess(context, 'Updated image',
              onPressed: () => Navigator.pop(context));
        }
        if (state is FailureUserState) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                _CoverAndProfile(size: size),
                const SizedBox(height: 20.0),
                const _UsernameAndDescription(),
                const SizedBox(height: 20.0),
                const _PostAndFollowingAndFollowers(),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (_, state) => state.isPhotos
                        ? const _ListFotosProfile()
                        : const _ListSaveProfile(),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavigationFrave(index: 5),
      ),
    );
  }
}

class _ListFotosProfile extends StatelessWidget {
  const _ListFotosProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostProfile>>(
        future: postService.getPostProfiles(),
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
              : GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      mainAxisExtent: 170),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final List<String> listImages =
                        snapshot.data![i].images.split(',');

                    return InkWell(
                      onTap: () => Navigator.push(context,
                          routeSlide(page: const ListPhotosProfilePage())),
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
                );
        });
  }
}

class _ListSaveProfile extends StatelessWidget {
  const _ListSaveProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListSavedPost>>(
      future: postService.getListPostSavedByUser(),
      builder: (context, snapshot) => !snapshot.hasData
          ? Column(
              children: const [
                ShimmerFrave(),
                SizedBox(height: 10.0),
                ShimmerFrave(),
                SizedBox(height: 10.0),
                ShimmerFrave(),
              ],
            )
          : GridView.builder(
              itemCount: snapshot.data!.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 2, mainAxisExtent: 170),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final List<String> listImages =
                    snapshot.data![i].images.split(',');
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      routeSlide(
                          page: SavedPostsPage(savedPost: snapshot.data!))),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  Environment.baseUrl + listImages.first)))),
                );
              }),
    );
  }
}

class _PostAndFollowingAndFollowers extends StatelessWidget {
  const _PostAndFollowingAndFollowers({Key? key}) : super(key: key);

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
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      routeSlide(page: const FollowingPage()),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomSpacer(
                          width: 10,
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (_, state) =>
                              state.postsUser?.friends != null
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0), // Keep padding for Followers
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      routeSlide(page: const FollowersPage()),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<UserBloc, UserState>(
                          builder: (_, state) => state.postsUser?.followers !=
                                  null
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
              ),
              Expanded(
                // Adjust the flex value as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0), // Keep padding for Post
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (_, state) => state.postsUser?.posters != null
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
              Spacer(), // Add Spacer to push Followers section to the left
            ],
          ),
        ],
      ),
    );
  }
}

class _UsernameAndDescription extends StatelessWidget {
  const _UsernameAndDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<UserBloc, UserState>(builder: (_, state) {
            if (state.user?.username != null) {
              if (state.user!.username != '') {
                // Call setState here when condition is true
                hellotheme.username = state.user!.username;
              }
              return TextCustom(
                color: hellotheme.secundary,
                text: state.user!.username,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ],
      ),
    );
  }
}

class _CoverAndProfile extends StatelessWidget {
  const _CoverAndProfile({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      width: size.width,
      child: Stack(
        children: [
          SizedBox(
            height: 360,
            width: size.width,
            child: BlocBuilder<UserBloc, UserState>(
                builder: (_, state) =>
                    (state.user?.cover != null && state.user?.cover != '')
                        ? Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                Environment.baseUrl + state.user!.cover))
                        : Container(
                            height: 360,
                            width: size.width,
                            color: hellotheme.background,
                          )),
          ),
          // Positioned(
          //   bottom: 28,
          //   child: Container(
          //     height: 40,
          //     width: size.width,
          //     decoration: const BoxDecoration(
          //         color: Color.fromARGB(150, 0, 0, 0),
          //         borderRadius:
          //             BorderRadius.vertical(top: Radius.circular(40.0))),
          //   ),
          // ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                height: 160,
                width: size.width,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.rectangle),
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (_, state) => (state.user?.image != null)
                          ? InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () => modalSelectPicture(
                                  context: context,
                                  title: 'Update profile image',
                                  onPressedImage: () async {
                                    Navigator.pop(context);
                                    AppPermission()
                                        .permissionAccessGalleryOrCameraForProfile(
                                            await Permission.photos.request(),
                                            context,
                                            ImageSource.gallery);
                                  },
                                  onPressedPhoto: () async {
                                    Navigator.pop(context);
                                    AppPermission()
                                        .permissionAccessGalleryOrCameraForProfile(
                                            await Permission.camera.request(),
                                            context,
                                            ImageSource.camera);
                                  }),
                              child: Container(
                                width: double
                                    .infinity, // Adjust the width as needed
                                height: double
                                    .infinity, // Adjust the height as needed
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(Environment.baseUrl +
                                        state.user!.image),
                                    fit: BoxFit
                                        .cover, // Adjust the fit as needed (cover, contain, etc.)
                                  ),
                                ),
                              ))
                          : const CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: IconButton(
                onPressed: () => modalProfileSetting(context, size),
                icon: Icon(Icons.dashboard_customize_outlined,
                    color: hellotheme.secundary),
              )),
          Positioned(
              right: 40,
              child: IconButton(
                splashRadius: 20,
                onPressed: () => modalSelectPicture(
                    context: context,
                    title: 'Update cover image',
                    onPressedImage: () async {
                      Navigator.pop(context);
                      AppPermission().permissionAccessGalleryOrCameraForCover(
                          await Permission.photos.request(),
                          context,
                          ImageSource.gallery);
                    },
                    onPressedPhoto: () async {
                      Navigator.pop(context);
                      AppPermission().permissionAccessGalleryOrCameraForCover(
                          await Permission.camera.request(),
                          context,
                          ImageSource.camera);
                    }),
                icon: Icon(Icons.add_box_outlined, color: hellotheme.secundary),
              ))
        ],
      ),
    );
  }
}
