// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:video_uploading/bloc/postEvent.dart';
import 'package:video_uploading/bloc/postState.dart';
import 'package:video_uploading/features/data/datasources/data_source_api.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRemoteDataSource postRemoteDataSource;
  PostBloc(
    {required this.postRemoteDataSource}
  ) : super(PostInitial()) {
    on<GetAllPostEvent>((event, emit) async {
      emit(PostLoading());
      
      try {
        final posts = await postRemoteDataSource.getAllPost();
        // final posts = postList.map((post) => post.toJson()).toList();
        emit(LoadedGetPostState(posts));
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });
  }
}
