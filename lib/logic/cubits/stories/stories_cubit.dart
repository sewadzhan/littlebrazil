import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/story_sections.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';

part 'stories_state.dart';

//Cubit for Stories
class StoriesCubit extends Cubit<StoriesState> {
  final FirestoreRepository firestoreRepository;

  StoriesCubit(this.firestoreRepository) : super(const StoriesLoadingState()) {
    getStories();
  }
  void getStories() async {
    // try {
    final List<StorySection> storiesSections =
        await firestoreRepository.getStories();

    emit(StoriesLoadedState(storySections: storiesSections));
    // } catch (e) {
    //   emit(const StoriesErrorState());
    // }
  }
}
