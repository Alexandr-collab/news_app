// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/blog_service.dart'; // Подключение сервиса для получения данных блога

class BlogDetails extends StatefulWidget {
  final int blogId; // Передаем только ID блога

  BlogDetails(this.blogId);

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  late Future<Blog> _blogFuture;
  late Blog _blog;

  @override
  void initState() {
    super.initState();
    _blogFuture = _fetchBlog(widget.blogId);
  }

  Future<Blog> _fetchBlog(int blogId) async {
    return BlogService(Dio()).getBlog(blogId);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Blog>(
      future: _blogFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _blog = snapshot.data!;
          return _buildBlogDetails();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                  'Loading...'), // Заголовок экрана во время загрузки
            ),
            body: const Center(
              child:
                  CircularProgressIndicator(), // Отображение индикатора загрузки
            ),
          );
        }
      },
    );
  }

  Widget _buildBlogDetails() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_blog.title), // Заголовок экрана
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            if (_blog.imageUrl != null)
              GestureDetector(
                onTap: () => _launchURL(_blog.url), // Переход в источник блога
                child: Image.network(
                  _blog.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              _blog.summary ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _launchURL(_blog.url), // Кнопка для перехода в источник блога
              child: const Text('Перейти в источник'),
            ),
          ],
        ),
      ),
    );
  }
}
