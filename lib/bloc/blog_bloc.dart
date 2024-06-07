import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/blog_service.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogService _blogService;

  BlogBloc(this._blogService) : super(BlogInitialState());

  Stream<BlogState> mapEventToState(BlogEvent event) async* {
    if (event is LoadBlogsEvent) {
      yield BlogLoadingState();
      try {
        BlogResponse response =
            await _blogService.getBlogs(event.offset, event.limit);
        yield BlogLoadedState(response.results);
      } catch (e) {
        yield BlogErrorState(e.toString());
      }
    }
  }
}

// Events
abstract class BlogEvent {}

class LoadBlogsEvent extends BlogEvent {
  final int offset;
  final int limit;

  LoadBlogsEvent(this.offset, this.limit);
}

// States
abstract class BlogState {}

class BlogInitialState extends BlogState {}

class BlogLoadingState extends BlogState {}

class BlogLoadedState extends BlogState {
  final List<Blog> blogs;

  BlogLoadedState(this.blogs);
}

class BlogErrorState extends BlogState {
  final String error;

  BlogErrorState(this.error);
}
