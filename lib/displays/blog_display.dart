import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:news_app/bloc/blog_bloc.dart';
import '../details/blog_detalis.dart';
import '../services/blog_service.dart';

class BlogDisplay extends StatelessWidget {
  final BlogBloc _blogBloc = BlogBloc(BlogService(Dio()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _blogBloc,
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogInitialState) {
            _blogBloc.add(LoadBlogsEvent(0, 10));
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Blog Display'),
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BlogState state) {
    if (state is BlogLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is BlogLoadedState) {
      return ListView.builder(
        itemCount: state.blogs.length,
        itemBuilder: (context, index) {
          var blog = state.blogs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetails(blog.id),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  if (blog.imageUrl != null)
                    Image.network(
                      blog.imageUrl!,
                      height: 80,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          blog.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          blog.summary ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (state is BlogErrorState) {
      return Center(child: Text('Error: ${state.error}'));
    } else {
      return const Center(child: Text('Something went wrong'));
    }
  }
}
