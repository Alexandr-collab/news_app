import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../details/news_details.dart';
import '../services/api_service.dart';
import '../utils/search_utils.dart';

class NewsDisplay extends StatefulWidget {
  @override
  _NewsDisplayState createState() => _NewsDisplayState();
}

class _NewsDisplayState extends State<NewsDisplay> {
  late ApiService _apiService;
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  int _offset = 0;
  int _limit = 10;
  bool _loading = false; // Флаг для отслеживания состояния загрузки
  String _currentSearchQuery = '';

  @override
  void initState() {
    _apiService = ApiService(Dio());
    _loadArticles();
    super.initState();
  }

  Future<void> _loadArticles() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      ArticleResponse response = await _apiService.getArticles(_offset, _limit);
      setState(() {
        _articles.addAll(response.results);
        _filteredArticles =
            SearchUtils.filterNews(_articles, _currentSearchQuery);
        _offset += _limit;
        _loading = false;
      });
    }
  }

  Future<void> _refreshArticles() async {
    setState(() {
      _articles = [];
      _offset = 0;
    });
    await _loadArticles();
  }

  void _filterArticles(String query) async {
    setState(() {
      _currentSearchQuery = query;
      if (query.isEmpty) {
        _filteredArticles = _articles.take(_offset).toList();
      } else {
        List<Article> filteredResults =
            SearchUtils.filterNews(_articles, query);
        _filteredArticles = filteredResults.take(_offset).toList();
        if (_filteredArticles.length < _offset) {
          _loadMoreArticles(query);
        }
      }
    });
  }

  Future<void> _loadMoreArticles(String query) async {
    int additionalOffset = _offset - _filteredArticles.length;
    if (additionalOffset > 0) {
      try {
        ArticleResponse response =
            await _apiService.getArticles(_offset, additionalOffset);
        setState(() {
          _articles.addAll(response.results);
          List<Article> filteredResults =
              SearchUtils.filterNews(_articles, query);
          _filteredArticles = filteredResults.take(_offset).toList();
          _offset += additionalOffset;
        });
      } catch (e) {
        print('Ошибка при загрузке дополнительных статей: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.extentAfter == 0) {
          _loadArticles(); // Вызываем загрузку при достижении конца списка
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  setState(() {
                    _currentSearchQuery = ''; // Очистка поисковой строки
                    _filteredArticles =
                        SearchUtils.filterNews(_articles, _currentSearchQuery);
                  });
                }
              },
              child: TextField(
                onChanged: (query) => _filterArticles(
                    query), // Обработчик изменения текста для поиска
                decoration: const InputDecoration(
                  labelText: 'Поиск',
                  hintText: 'Введите запрос для поиска статей',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredArticles.length,
                itemBuilder: (context, index) {
                  var article = _filteredArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetails(article.id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(
                          8), // Добавьте отступы по вашему усмотрению
                      child: Row(
                        children: <Widget>[
                          if (article.imageUrl != null)
                            Image.network(
                              article.imageUrl!,
                              height: 80,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(
                              width:
                                  8), // Добавьте отступы между изображением и текстом
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    height:
                                        4), // Добавьте вертикальные отступы по вашему усмотрению
                                Text(
                                  article.summary ?? '',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
