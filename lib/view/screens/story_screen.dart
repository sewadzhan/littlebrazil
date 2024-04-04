import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/story_screen_argument.dart';
import 'package:littlebrazil/view/screens/story_section_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key, required this.storyScreenArgument});

  final StoryScreenArgument storyScreenArgument;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late PageController pageController;
  @override
  void initState() {
    pageController =
        PageController(initialPage: widget.storyScreenArgument.start);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: pageController,
          physics: const ClampingScrollPhysics(),
          itemBuilder: ((context, index) => StorySectionScreen(
                storySection: widget.storyScreenArgument.storySections[
                    index % widget.storyScreenArgument.storySections.length],
                mainPageController: pageController,
              )),
        ));
  }
}
