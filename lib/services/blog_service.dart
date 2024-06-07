import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog_service.g.dart';

@RestApi(baseUrl: "https://api.spaceflightnewsapi.net")
abstract class BlogService {
  factory BlogService(Dio dio, {String baseUrl}) = _BlogService;

  @GET("/v4/blogs/")
  Future<BlogResponse> getBlogs(
      @Query("offset") int offset, @Query("limit") int limit);

  @GET("/v4/blogs/{id}/")
  Future<Blog> getBlog(@Path("id") int id);
}

@JsonSerializable()
class BlogResponse {
  int count;
  String? next;
  String? previous;
  List<Blog> results;

  BlogResponse(
      {required this.count, this.next, this.previous, required this.results});

  factory BlogResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BlogResponseToJson(this);
}

@JsonSerializable()
class Blog {
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

  Blog({
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

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
  Map<String, dynamic> toJson() => _$BlogToJson(this);
}

@JsonSerializable()
class Launch {
  String? launchId;
  String provider;

  Launch({this.launchId, required this.provider});

  factory Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);
  Map<String, dynamic> toJson() => _$LaunchToJson(this);
}

@JsonSerializable()
class Event {
  int eventId;
  String provider;

  Event({required this.eventId, required this.provider});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
