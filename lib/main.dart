import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'displays/news_display.dart';
import 'displays/blog_display.dart';
import 'displays/app_info_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService(Dio());

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Space Flight News'),
          ),
          body: TabBarView(
            children: [
              NewsDisplay(), // Передача apiService в NewsDisplay
              BlogDisplay(),
              AppInfoWidget(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article), text: 'Новости'),
              Tab(icon: Icon(Icons.book), text: 'Блоги'),
              Tab(icon: Icon(Icons.info), text: 'О приложении'),
            ],
          ),
        ),
      ),
    );
  }
}
