import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'news_display.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService =
      ApiService(Dio()); // Создаем экземпляр ApiService с Dio

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Space Flight News'),
        ),
        body: FutureBuilder<ArticleResponse>(
          future: apiService.getArticles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Ошибка при загрузке данных: ${snapshot.error}'),
              ); // Отображаем сообщение об ошибке и информацию о причине
            } else {
              // Отображаем виджет для списка новостей
              return snapshot.data != null
                  ? NewsDisplay(snapshot.data!.results)
                  : Container();
            }
          },
        ),
      ),
    );
  }
}
