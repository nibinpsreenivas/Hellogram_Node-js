import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/blocs/post/post_bloc.dart';
import 'package:hellogram/domain/models/response/response_post.dart';
import 'package:hellogram/domain/services/post_services.dart';
import 'package:hellogram/domain/services/user_services.dart';
import 'package:hellogram/domain/models/response/response_search.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/helpers/modal_show_post.dart';
import 'package:hellogram/ui/screens/emotion/emotion.dart';
import 'package:hellogram/ui/screens/profile/profile_another_user_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> compareFaces(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://192.168.136.74:5000/compare'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'photo': base64Encode(_image!.readAsBytesSync()),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Match found for user: ${data['username']}');
      Fluttertoast.showToast(msg: "Match found for user: ${data['username']}");
      setState(() {
        _searchController.text = data['username'];
        String newString = _searchController.text
            .substring(0, _searchController.text.length - 1);
        userService.searchUsers(newString);
      });
    } else {
      print('No match found');
      Fluttertoast.showToast(msg: "No match found");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      backgroundColor: hellotheme.primary,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 10.0),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                height: 45,
                width: size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(80, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0)),
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) => TextField(
                    style: TextStyle(color: hellotheme.secundary),
                    controller: _searchController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        postBloc.add(OnIsSearchPostEvent(true));
                        userService.searchUsers(value);
                      } else {
                        postBloc.add(OnIsSearchPostEvent(false));
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Find a friend',
                        hintStyle: GoogleFonts.roboto(fontSize: 17),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.camera_enhance_rounded,
                            size: 35,
                            color: hellotheme.secundary,
                          ),
                          onTap: () async {
                            await _pickImage();
                            if (_image != null) {
                              await compareFaces(context);
                            }
                          },
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            BlocBuilder<PostBloc, PostState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) => !state.isSearchFriend
                    ? FutureBuilder<List<Post>>(
                        future: postService.getAllPostsForSearch(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? const _ShimerSearch()
                              : _GridPostSearch(posts: snapshot.data!);
                        },
                      )
                    : streamSearchUser())
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationFrave(index: 2),
    );
  }

  Widget streamSearchUser() {
    return StreamBuilder<List<UserFind>>(
      stream: userService.searchProducts,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Container();

        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        if (snapshot.data!.isEmpty) {
          return ListTile(
            title: TextCustom(text: 'No results for ${_searchController.text}'),
          );
        }

        return _ListUsers(listUser: snapshot.data!);
      },
    );
  }
}

class _ListUsers extends StatelessWidget {
  final List<UserFind> listUser;

  const _ListUsers({
    Key? key,
    required this.listUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listUser.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                routeSlide(
                    page: ProfileAnotherUserPage(idUser: listUser[i].uid)));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              color: Color.fromARGB(23, 128, 0, 126),
              padding: const EdgeInsets.only(left: 5.0),
              height: 70,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(Environment.baseUrl + listUser[i].avatar),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextCustom(
                          color: hellotheme.secundary,
                          text: listUser[i].username),
                      TextCustom(
                          text: listUser[i].fullname, color: Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridPostSearch extends StatelessWidget {
  final List<Post> posts;

  const _GridPostSearch({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            mainAxisExtent: 170),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final List<String> listImages = posts[i].images.split(',');

          return GestureDetector(
            onTap: () {},
            onLongPress: () => modalShowPost(context, post: posts[i]),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            Environment.baseUrl + listImages.first)))),
          );
        });
  }
}

class _ShimerSearch extends StatelessWidget {
  const _ShimerSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        // children: const [
        //   ShimmerFrave(),
        //   SizedBox(height: 10.0),
        //   ShimmerFrave(),
        //   SizedBox(height: 10.0),
        //   ShimmerFrave(),
        // ],
        );
  }
}
