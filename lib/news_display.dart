import 'package:flutter/material.dart';
import 'api_service.dart';

class NewsDisplay extends StatelessWidget {
  final List<Article> news;

  NewsDisplay(this.news);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(news[index]
              .title), // Обращение к свойству title напрямую из объекта Article
          subtitle: Text(news[index].summary ??
              ''), // Обращение к свойству summary напрямую из объекта Article
          onTap: () {
            //обработчик onTap для открытия полной новости
          },
        );
      },
    );
  }
}
