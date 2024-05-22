// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blog_service.dart'; // Подключите модель данных блога

class BlogDetails extends StatelessWidget {
  final Blog blog;

  BlogDetails(this.blog);

  // Функция для открытия полной статьи в браузере
  _launchURL() async {
    if (await canLaunch(blog.url)) {
      await launch(blog.url);
    } else {
      throw 'Could not launch ${blog.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            if (blog.imageUrl != null)
              GestureDetector(
                onTap: _launchURL,
                child: Image.network(
                  blog.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              blog.summary ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _launchURL,
              child: Text('Читать полностью'),
            ),
          ],
        ),
      ),
    );
  }
}
