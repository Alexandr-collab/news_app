import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.spaceflightnewsapi.net")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/v4/articles/")
  Future<ArticleResponse> getArticles(
      @Query("offset") int offset, @Query('limit') int limit);

  @GET("/v4/articles/{id}/")
  Future<Article> getArticle(@Path("id") int id);
}

@JsonSerializable()
class ArticleResponse {
  int count;
  String? next;
  String? previous;
  List<Article> results;

  ArticleResponse(
      {required this.count, this.next, this.previous, required this.results});

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);
}

@JsonSerializable()
class Article {
  int id;
  String title;
  String url;
  String? imageUrl;
  String? newsSite;
  String? summary;
  DateTime? publishedAt;
  DateTime? updatedAt;
  bool featured;
  List<Launch> launches;
  List<Event> events;

  Article({
    required this.id,
    required this.title,
    required this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
    this.updatedAt,
    required this.featured,
    required this.launches,
    required this.events,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class Launch {
  String? launchId;
  String provider;

  Launch({this.launchId, required this.provider});

  factory Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);
  Map<String, dynamic> toJson() => _$LaunchToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Event {
  int eventId;
  String provider;

  Event({required this.eventId, required this.provider});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
