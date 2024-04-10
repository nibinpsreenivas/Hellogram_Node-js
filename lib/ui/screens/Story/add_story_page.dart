import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/domain/blocs/story/story_bloc.dart';
import 'package:hellogram/ui/helpers/animation_route.dart';
import 'package:hellogram/ui/helpers/error_message.dart';
import 'package:hellogram/ui/helpers/modal_loading.dart';
import 'package:hellogram/ui/helpers/modal_success.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:hellogram/ui/screens/home/home_page.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({Key? key}) : super(key: key);

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  late List<AssetEntity> _mediaList = [];
  late File fileImage;

  @override
  void initState() {
    _assetImagesDevice();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _assetImagesDevice() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);

      if (albums.isNotEmpty) {
        List<AssetEntity> photos =
            await albums[0].getAssetListPaged(page: 0, size: 90);
        setState(() => _mediaList = photos);
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final storyBloc = BlocProvider.of<StoryBloc>(context);

    return BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state is LoadingStory) {
          modalLoading(
            context,
            'Charging...',
          );
        } else if (state is FailureStory) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessStory) {
          Navigator.pop(context);
          modalSuccess(
            context,
            'Story addedc !',
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: const HomePage()), (_) => false),
          );
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        appBar: AppBar(
          backgroundColor: hellotheme.primary,
          elevation: 0,
          title: const TextCustom(
            text: 'Gallery',
            fontSize: 19,
            letterSpacing: .8,
          ),
          leading: IconButton(
              splashRadius: 20,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: hellotheme.secundary)),
          actions: [
            BlocBuilder<StoryBloc, StoryState>(
              builder: (context, state) => TextButton(
                  onPressed: () {
                    if (state.image != null) {
                      storyBloc.add(OnAddNewStoryEvent(state.image!.path));
                    }
                  },
                  child: TextCustom(
                    text: 'Post',
                    fontSize: 17,
                    color: hellotheme.background,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<StoryBloc, StoryState>(
                builder: (_, state) => state.image != null
                    ? GestureDetector(
                        onTap: () => _assetImagesDevice(),
                        child: Container(
                          height: size.height * .4,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: hellotheme.secundary,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(state.image!))),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => _assetImagesDevice(),
                        child: Container(
                          height: size.height * .4,
                          width: size.width,
                          color: hellotheme.secundary,
                          child: Icon(Icons.wallpaper_rounded,
                              color: hellotheme.background, size: 90),
                        ),
                      )),

            // Expanded(
            //   child: Container(
            //     height: size.height,
            //     width: size.width,
            //     color: Colors.black,
            //     child: GridView.builder(
            //       itemCount: _mediaList.length,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3,
            //         crossAxisSpacing: 1,
            //         mainAxisSpacing: 1,
            //       ),
            //       itemBuilder: (context, i) {
            //         return InkWell(
            //           onTap: () async {
            //             fileImage = (await _mediaList[i].file)!;
            //             storyBloc.add(OnSelectedImagePreviewEvent(fileImage));
            //           },
            //           child: FutureBuilder(
            //             future: _mediaList[i].thumbDataWithSize(200, 200),
            //             builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
            //               if (snapshot.connectionState == ConnectionState.done) {
            //                 return Container(
            //                   height: 85,
            //                   width: 100,
            //                   decoration: BoxDecoration(
            //                       image: DecorationImage(
            //                           fit: BoxFit.cover,
            //                           image: MemoryImage(snapshot.data!)
            //                       )
            //                   ),
            //                 );
            //               }
            //               return const SizedBox();
            //             },
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
