import 'package:flutter/material.dart';
import 'NewsDetails.dart';
import 'api_service.dart';

class NewsDisplay extends StatefulWidget {
  final List<Article> news;

  NewsDisplay(this.news);

  @override
  _NewsDisplayState createState() => _NewsDisplayState();
}

class _NewsDisplayState extends State<NewsDisplay> {
  List<Article> filteredNews = [];
  String currentQuery = '';

  @override
  void initState() {
    filteredNews = widget.news;
    super.initState();
  }

  Future<void> _refreshNews() async {
    setState(() {
      currentQuery = '';
      filteredNews = widget.news;
    });
  }

  void filterNews(String query) {
    setState(() {
      currentQuery = query;
      filteredNews = widget.news
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()) ||
              (article.summary != null &&
                  article.summary!.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            // Виджет для вкладки "Новости"
            RefreshIndicator(
              onRefresh: _refreshNews,
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (query) => filterNews(query),
                    decoration: const InputDecoration(
                      labelText: 'Поиск',
                      hintText: 'Введите запрос для поиска новостей',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredNews.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredNews[index].title),
                          subtitle: Text(filteredNews[index].summary ?? ''),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetails(filteredNews[index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Виджет для вкладки "Блоги"
            buildBlogTab(), // Вызов метода для создания виджета блогов
            // Виджет для вкладки "О приложении"
            buildAppInfoTab(), // Вызов метода для создания виджета информации о приложении
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
    );
  }

// Виджет для вкладки "Блоги"
  Widget buildBlogTab() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Заголовок поста в блоге 1'),
          subtitle: const Text('Краткое описание поста в блоге 1'),
          onTap: () {
            // Обработка нажатия на пост блога 1
          },
        ),
        ListTile(
          title: const Text('Заголовок поста в блоге 2'),
          subtitle: const Text('Краткое описание поста в блоге 2'),
          onTap: () {
            // Обработка нажатия на пост блога 2
          },
          // Добавьте другие посты блога по аналогии
        )
      ],
    );
  }
}

// Виджет для вкладки "О приложении"
Widget buildAppInfoTab() {
  return const SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'О приложении',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'информацию о приложении, его возможностях, контактной информации и т.д.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
