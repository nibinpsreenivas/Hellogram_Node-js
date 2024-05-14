import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hellogram/data/env/env.dart';
import 'package:hellogram/domain/models/response/response_list_stories.dart';
import 'package:hellogram/domain/models/response/response_stories.dart';
import 'package:hellogram/domain/services/story_services.dart';
import 'package:hellogram/ui/screens/Story/widgets/animated_line.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

class ViewStoryPage extends StatefulWidget {
  final StoryHome storyHome;

  const ViewStoryPage({Key? key, required this.storyHome}) : super(key: key);

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentStory = 0;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: .99);
    _animationController = AnimationController(vsync: this);

    _showStory();
    _animationController.addStatusListener(_statusListener);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_statusListener);
    _animationController.dispose();

    _pageController.dispose();
    super.dispose();
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextStory();
    }
  }

  void _showStory() {
    _animationController
      ..reset()
      ..duration = const Duration(seconds: 4)
      ..forward();
  }

  void _nextStory() {
    if (_currentStory < widget.storyHome.countStory - 1) {
      setState(() => _currentStory++);

      _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuint);
      _showStory();
    }
  }

  void _previousStory() {
    if (_currentStory > 0) {
      setState(() => _currentStory--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuint);
      _showStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: hellotheme.primary,
      body: FutureBuilder<List<ListStory>>(
        future: storyServices.getStoryByUSer(widget.storyHome.uidStory),
        builder: (context, snapshot) {
          final List<String> listImages = snapshot.data![0].media.split(',');
          return !snapshot.hasData
              ? const ShimmerFrave()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        if (details.globalPosition.dx < size.width / 2) {
                          _previousStory();
                          print(snapshot.data?[0].media);
                        } else {
                          _nextStory();
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30.0),

                          // * Animated Line //
                          Row(
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      child: AnimatedLineStory(
                                          index: index,
                                          selectedIndex: _currentStory,
                                          animationController:
                                              _animationController),
                                    ))),
                          ),

                          const SizedBox(height: 20.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    Environment.baseUrl +
                                        widget.storyHome.avatar),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(
                                        text: widget.storyHome.username,
                                        color: hellotheme.secundary),
                                    TextCustom(
                                        text: 'story',
                                        color: hellotheme.secundary,
                                        fontSize: 14)
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.close,
                                    color: hellotheme.secundary,
                                  ))
                            ],
                          ),
                          Container(
                            child: Image.network(
                                Environment.baseUrl + listImages[0]),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.white.withOpacity(.1),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 20.0),
                                          hintText: 'Write a comment',
                                          hintStyle: GoogleFonts.roboto(
                                              color: hellotheme.secundary)),
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10.0),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.send_rounded,
                                      color: hellotheme.secundary))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
