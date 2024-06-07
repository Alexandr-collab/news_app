// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart'; // Подключение сервиса для получения данных новостей

class NewsDetails extends StatefulWidget {
  final int newsId; // Передаем только ID новости

  NewsDetails(this.newsId);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  late Future<Article> _articleFuture;
  late Article _article;

  @override
  void initState() {
    super.initState();
    _articleFuture = _fetchArticle(widget.newsId);
  }

  Future<Article> _fetchArticle(int newsId) async {
    return ApiService(Dio()).getArticle(newsId);
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
    return FutureBuilder<Article>(
      future: _articleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _article = snapshot.data!;
          return _buildNewsDetails();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                  'Загрузка...'), // Заголовок экрана во время загрузки
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

  Widget _buildNewsDetails() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_article.title), // Заголовок экрана
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8),
            if (_article.imageUrl != null)
              GestureDetector(
                onTap: () =>
                    _launchURL(_article.url), // Переход в источник новости
                child: Image.network(
                  _article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              _article.summary ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL(
                  _article.url), // Кнопка для перехода в источник новости
              child: const Text('Читать полностью'),
            ),
          ],
        ),
      ),
    );
  }
}
