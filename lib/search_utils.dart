import 'api_service.dart';
import 'blog_service.dart';

class SearchUtils {
  static List<Article> filterNews(List<Article> news, String query) {
    return news
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            (article.summary != null &&
                article.summary!.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }
}

class SearchBlogs {
  static List<Blog> filterBlogs(List<Blog> blogs, String query) {
    return blogs
        .where((blog) =>
            blog.title.toLowerCase().contains(query.toLowerCase()) ||
            (blog.summary != null &&
                blog.summary!.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }
}
