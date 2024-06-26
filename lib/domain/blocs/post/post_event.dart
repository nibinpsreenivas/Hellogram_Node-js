part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class OnPrivacyPostEvent extends PostEvent {
  final int privacyPost;

  OnPrivacyPostEvent(this.privacyPost);
}

class OnSelectedImageEvent extends PostEvent {
  final File imageSelected;

  OnSelectedImageEvent(this.imageSelected);
}

class OnClearSelectedImageEvent extends PostEvent {
  final int indexImage;

  OnClearSelectedImageEvent(this.indexImage);
}

class OnAddNewPostEvent extends PostEvent {
  final String comment;
  final String post_emotion;

  OnAddNewPostEvent(this.comment, this.post_emotion);
}

class OndelNewPostEvent extends PostEvent {
  final String idPost;
  OndelNewPostEvent(this.idPost);
}

class OnSavePostByUser extends PostEvent {
  final String idPost;

  OnSavePostByUser(this.idPost);
}

class OnIsSearchPostEvent extends PostEvent {
  final bool isSearchFriend;

  OnIsSearchPostEvent(this.isSearchFriend);
}

class OnNewStoryEvent extends PostEvent {}

class OnLikeOrUnLikePost extends PostEvent {
  final String uidPost;
  final String uidPerson;

  OnLikeOrUnLikePost(this.uidPost, this.uidPerson);
}

class OnAddNewCommentEvent extends PostEvent {
  final String uidPost;
  final String comment;

  OnAddNewCommentEvent(this.uidPost, this.comment);
}

class OnLikeOrUnlikeComment extends PostEvent {
  final String uidComment;

  OnLikeOrUnlikeComment(this.uidComment);
}
