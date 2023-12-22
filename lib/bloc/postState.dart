import 'package:equatable/equatable.dart';
import 'package:video_uploading/features/data/models/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostError extends PostState {
  final String errorMessage;

  PostError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LoadedGetPostState extends PostState {
  final List<Post> posts;

  const LoadedGetPostState(this.posts);

  @override
  List<Object> get props => [posts];
}