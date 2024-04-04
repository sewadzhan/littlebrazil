import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/story.dart';

//Model of stories section for Home Screen
class StorySection extends Equatable {
  final String title;
  final String imageUrl;
  final List<Story> stories;

  const StorySection(
      {required this.title, required this.imageUrl, this.stories = const []});

  @override
  List<Object?> get props => [title, imageUrl, stories];

  factory StorySection.fromMap(Map<String, dynamic> map) {
    List<dynamic> tmp = map['stories'];
    return StorySection(
        title: map['title'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        stories: tmp.map((e) => Story.fromMap(e)).toList());
  }
}
