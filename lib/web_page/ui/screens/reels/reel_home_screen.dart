import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hellogram/web_page/ui/screens/reels/widgets/modal_more_option.dart';
import 'package:hellogram/web_page/ui/themes/hellotheme.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class ReelHomeScreen extends StatefulWidget {
  const ReelHomeScreen({Key? key}) : super(key: key);

  @override
  _ReelHomeScreenState createState() => _ReelHomeScreenState();
}

class _ReelHomeScreenState extends State<ReelHomeScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  int _currentVideoIndex = 0;
  final List<String> _videoUrls = [
    "assets/insta.mp4",
    "assets/insta1.mp4",
    "assets/insta2.mp4",
    "assets/insta3.mp4",
    // Add more video URLs as needed
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(_videoUrls[_currentVideoIndex]);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  void _playNextVideo() {
    setState(() {
      _currentVideoIndex = (_currentVideoIndex + 1) % _videoUrls.length;
      _controller = VideoPlayerController.asset(_videoUrls[_currentVideoIndex]);
      _chewieController.dispose();
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swiped up
          _playNextVideo();
        }
      },
      child: Scaffold(
        backgroundColor: hellotheme.primary,
        body: Stack(
          children: [
            Chewie(
              controller: _chewieController,
            ),
            Positioned(
              left: 15,
              top: 30,
              child: Image(
                color: hellotheme.secundary,
                image: AssetImage('assets/img/hello.png'),
                height: 35,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User information, description, etc.
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 15,
                          backgroundImage: AssetImage(
                            'assets/img/logo.png',
                          )),
                      const SizedBox(width: 10.0),
                      TextCustom(
                          text: 'insta sample',
                          color: hellotheme.secundary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0),
                      const SizedBox(width: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: hellotheme.secundary)),
                        child: TextCustom(
                          text: 'follow',
                          color: hellotheme.secundary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  TextCustom(
                    text: 'Description',
                    fontSize: 14,
                    color: hellotheme.secundary,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note_rounded,
                        color: hellotheme.secundary,
                        size: 15,
                      ),
                      SizedBox(width: 5.0),
                      TextCustom(
                        text: 'hellogram',
                        color: hellotheme.secundary,
                        fontSize: 14.0,
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 20,
              child: Column(
                children: [
                  // Like, comment, share icons
                  Column(
                    children: [
                      Icon(Icons.favorite_border_rounded,
                          color: hellotheme.secundary, size: 30),
                      SizedBox(height: 5.0),
                      TextCustom(
                        text: '524',
                        color: hellotheme.secundary,
                        fontSize: 13,
                      )
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/message-icon.svg',
                        height: 30,
                      ),
                      const SizedBox(height: 5.0),
                      TextCustom(
                        text: '1504',
                        color: hellotheme.secundary,
                        fontSize: 13,
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Icon(Icons.share_outlined,
                      color: hellotheme.secundary, size: 26),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                      onTap: () => modalOptionsReel(context),
                      child: Icon(Icons.more_vert_rounded,
                          color: hellotheme.secundary, size: 26)),
                  const SizedBox(height: 20.0),
                  Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Image.asset('assets/img/logo.png'))
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            const BottomNavigationFrave(index: 3, isReel: true),
      ),
    );
  }
}
