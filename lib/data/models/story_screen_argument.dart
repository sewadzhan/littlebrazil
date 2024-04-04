import 'package:littlebrazil/data/models/story_sections.dart';

class StoryScreenArgument {
  final List<StorySection> storySections;
  final int start;

  StoryScreenArgument({required this.storySections, required this.start});
}
