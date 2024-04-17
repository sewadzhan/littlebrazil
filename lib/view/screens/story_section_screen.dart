import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/data/models/story.dart';
import 'package:littlebrazil/data/models/story_sections.dart';
import 'package:littlebrazil/view/components/animated_bar.dart';
import 'package:littlebrazil/view/config/config.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:video_player/video_player.dart';

class StorySectionScreen extends StatefulWidget {
  const StorySectionScreen(
      {super.key,
      required this.storySection,
      required this.mainPageController});

  final StorySection storySection;
  final PageController mainPageController;

  @override
  State<StorySectionScreen> createState() => __StorySectionScreenStateState();
}

class __StorySectionScreenStateState extends State<StorySectionScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late VideoPlayerController videoController;
  late AnimationController animationController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    animationController = AnimationController(vsync: this);

    final Story firstStory = widget.storySection.stories.first;
    loadStory(story: firstStory, animateToPage: false);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        setState(() {
          if (currentIndex + 1 < widget.storySection.stories.length) {
            currentIndex += 1;
            loadStory(story: widget.storySection.stories[currentIndex]);
          } else {
            // Out of bounds - next story section
            widget.mainPageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.storySection.stories[currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => onTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.storySection.stories.length,
                itemBuilder: (context, index) {
                  Story story = widget.storySection.stories[index];
                  switch (story.media) {
                    case StoryMediaType.image:
                      return CachedNetworkImage(
                        imageUrl: story.url,
                        fit: BoxFit.cover,
                      );
                    case StoryMediaType.video:
                      if (videoController.value.isInitialized) {
                        return FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: videoController.value.size.width,
                            height: videoController.value.size.height,
                            child: VideoPlayer(videoController),
                          ),
                        );
                      }
                  }
                  return const SizedBox.shrink();
                }),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 0.5,
                    left: Constants.defaultPadding,
                    right: Constants.defaultPadding),
                child: Column(
                  children: [
                    Row(
                      children: widget.storySection.stories
                          .asMap()
                          .map((i, e) {
                            return MapEntry(
                              i,
                              AnimatedBar(
                                animController: animationController,
                                position: i,
                                currentIndex: currentIndex,
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Constants.defaultPadding * 0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${story.publishDate.day} ${Config.getMonthString(story.publishDate.month)}",
                            style: Constants.textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            child: SizedBox(
                              width: 25,
                              child: SvgPicture.asset('assets/icons/cross.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (currentIndex - 1 >= 0) {
          currentIndex -= 1;
          loadStory(story: widget.storySection.stories[currentIndex]);
        } else {
          widget.mainPageController.previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.ease);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (currentIndex + 1 < widget.storySection.stories.length) {
          currentIndex += 1;
          loadStory(story: widget.storySection.stories[currentIndex]);
        } else {
          // Out of bounds - next Story Section
          widget.mainPageController.nextPage(
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        }
      });
    } else {
      if (story.media == StoryMediaType.video) {
        if (videoController.value.isPlaying) {
          videoController.pause();
          animationController.stop();
        } else {
          videoController.play();
          animationController.forward();
        }
      }
    }
  }

  void loadStory({required Story story, bool animateToPage = true}) {
    animationController.stop();
    animationController.reset();
    switch (story.media) {
      case StoryMediaType.image:
        animationController.duration = story.duration;
        animationController.forward();
        break;
      case StoryMediaType.video:
        videoController = VideoPlayerController.networkUrl(Uri.parse(story.url))
          ..initialize().then((_) {
            setState(() {});
            if (videoController.value.isInitialized) {
              animationController.duration = videoController.value.duration;
              videoController.play();
              animationController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
