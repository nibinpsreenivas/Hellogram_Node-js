part of 'post_bloc.dart';

@immutable
class PostState {
  final int privacyPost;
  final List<File>? imageFileSelected;
  final bool isSearchFriend;
  final String post_emotion;

  const PostState({
    this.post_emotion = '',
    this.privacyPost = 1,
    this.imageFileSelected,
    this.isSearchFriend = false,
  });

  PostState copyWith({
    int? privacyPost,
    String? post_emotion = '',
    List<File>? imageFileSelected,
    bool? isSearchFriend,
  }) =>
      PostState(
        privacyPost: privacyPost ?? this.privacyPost,
        imageFileSelected: imageFileSelected ?? this.imageFileSelected,
        isSearchFriend: isSearchFriend ?? this.isSearchFriend,
        post_emotion: post_emotion ?? this.post_emotion,
      );
}

class LoadingPost extends PostState {}

class LoadingSavePost extends PostState {}

class FailurePost extends PostState {
  final String error;

  const FailurePost(this.error);
}

class SuccessPost extends PostState {}

class LoadingStory extends PostState {}

class SuccessStory extends PostState {}
