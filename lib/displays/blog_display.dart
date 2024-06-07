import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../details/blog_detalis.dart';
import '../services/blog_service.dart';
import '../utils/search_utils.dart';

class BlogDisplay extends StatefulWidget {
  @override
  _BlogDisplayState createState() => _BlogDisplayState();
}

class _BlogDisplayState extends State<BlogDisplay> {
  late BlogService _blogService;
  List<Blog> _blogs = [];
  List<Blog> _filteredBlogs = [];
  int _offset = 0;
  int _limit = 10;
  bool _loading = false; // Флаг для отслеживания состояния загрузки
  String _currentSearchQuery = '';

  @override
  void initState() {
    _blogService = BlogService(Dio());
    _loadBlogs();
    super.initState();
  }

  Future<void> _loadBlogs() async {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
      try {
        BlogResponse response = await _blogService.getBlogs(_offset, _limit);
        setState(() {
          _blogs.addAll(response.results);
          _filteredBlogs = SearchBlogs.filterBlogs(_blogs,
              _currentSearchQuery); // Используем текущий запрос поиска для фильтрации
          _offset += _limit;
          _loading = false;
        });
      } catch (e) {
        print('Ошибка при загрузке блогов: $e');
        _loading = false;
      }
    }
  }

  Future<void> _refreshBlogs() async {
    setState(() {
      _blogs = []; // Очистить список блогов
      _offset = 0; // Сбросить смещение при обновлении
    });
    await _loadBlogs();
  }

  void _filterBlogs(String query) async {
    setState(() {
      _currentSearchQuery = query; // Обновляем текущий запрос поиска
      if (query.isEmpty) {
        _filteredBlogs = _blogs
            .take(_offset)
            .toList(); // Показать первые _offset результатов без фильтрации
      } else {
        List<Blog> filteredResults = SearchBlogs.filterBlogs(_blogs, query);
        _filteredBlogs = filteredResults
            .take(_offset)
            .toList(); // Фильтрация и пагинация результатов поиска
        if (_filteredBlogs.length < _offset) {
          _loadMoreBlogs(
              query); // Если количество отфильтрованных результатов меньше, чем _offset, загрузить больше блогов
        }
      }
    });
  }

  Future<void> _loadMoreBlogs(String query) async {
    int additionalOffset = _offset - _filteredBlogs.length;
    if (additionalOffset > 0) {
      try {
        BlogResponse response =
            await _blogService.getBlogs(_offset, additionalOffset);
        setState(() {
          _blogs.addAll(response.results);
          List<Blog> filteredResults = SearchBlogs.filterBlogs(_blogs, query);
          _filteredBlogs = filteredResults
              .take(_offset)
              .toList(); // Обновление отфильтрованных результатов после загрузки дополнительных блогов
          _offset += additionalOffset;
        });
      } catch (e) {
        print('Ошибка при загрузке дополнительных блогов: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.extentAfter == 0) {
          _loadBlogs(); // Вызываем загрузку при достижении конца списка
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: _refreshBlogs,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  setState(() {
                    _currentSearchQuery = ''; // Очистка поисковой строки
                    _filteredBlogs =
                        SearchBlogs.filterBlogs(_blogs, _currentSearchQuery);
                  });
                }
              },
              child: TextField(
                onChanged: (query) => _filterBlogs(
                    query), // Обработчик изменения текста для поиска
                decoration: const InputDecoration(
                  labelText: 'Поиск',
                  hintText: 'Введите запрос для поиска блогов',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredBlogs.length,
                itemBuilder: (context, index) {
                  var blog = _filteredBlogs[index];
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
                      padding: const EdgeInsets.all(
                          8), // Добавьте отступы по вашему усмотрению
                      child: Row(
                        children: <Widget>[
                          if (blog.imageUrl != null)
                            Image.network(
                              blog.imageUrl!,
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
                                  blog.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                    height:
                                        4), // Добавьте вертикальные отступы по вашему усмотрению
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
