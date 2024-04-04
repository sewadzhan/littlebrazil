part of 'stories_cubit.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object?> get props => [];
}

class StoriesLoadingState extends StoriesState {
  const StoriesLoadingState();
}

class StoriesLoadedState extends StoriesState {
  final List<StorySection> storySections;

  const StoriesLoadedState({required this.storySections});

  @override
  List<Object?> get props => [storySections];
}

class StoriesErrorState extends StoriesState {
  const StoriesErrorState();
}
