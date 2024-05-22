import 'package:flutter/material.dart';
import 'NewsDetails.dart';
import 'api_service.dart';
import 'blog_display.dart';
import 'app_info_widget.dart';
import 'search_utils.dart';

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
      filteredNews = SearchUtils.filterNews(widget.news,
          query); // Использование функции поиска из отдельного файла
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
            BlogDisplay(), // Виджет для вкладки "Блоги" из отдельного файла
            AppInfoWidget(), // Виджет для вкладки "О приложении" из отдельного файла
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
}
