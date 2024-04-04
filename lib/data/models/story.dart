import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum StoryMediaType { image, video }

class Story extends Equatable {
  final String url;
  final StoryMediaType media;
  final Duration duration;
  final DateTime publishDate;

  const Story({
    required this.url,
    required this.media,
    this.duration = const Duration(seconds: 10),
    required this.publishDate,
  });

  @override
  List<Object?> get props => [url, media, duration, publishDate];

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      url: map['url'] ?? '',
      media:
          map['type'] == 'video' ? StoryMediaType.video : StoryMediaType.image,
      duration: map['duration'] ?? const Duration(seconds: 10),
      publishDate: (map['publishDate'] as Timestamp).toDate(),
    );
  }
}
