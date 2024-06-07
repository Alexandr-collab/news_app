// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    ArticleResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      url: json['url'] as String,
      imageUrl: json['image_url'] as String?,
      newsSite: json['newsSite'] as String?,
      summary: json['summary'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      featured: json['featured'] as bool,
      launches: (json['launches'] as List<dynamic>)
          .map((e) => Launch.fromJson(e as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'newsSite': instance.newsSite,
      'summary': instance.summary,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'featured': instance.featured,
      'launches': instance.launches,
      'events': instance.events,
    };

Launch _$LaunchFromJson(Map<String, dynamic> json) => Launch(
      launchId: json['launchId'] as String?,
      provider: json['provider'] as String,
    );

Map<String, dynamic> _$LaunchToJson(Launch instance) => <String, dynamic>{
      'launchId': instance.launchId,
      'provider': instance.provider,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      eventId: (json['event_id'] as num).toInt(),
      provider: json['provider'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'event_id': instance.eventId,
      'provider': instance.provider,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.spaceflightnewsapi.net';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ArticleResponse> getArticles(
    int offset,
    int limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'limit': limit,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ArticleResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/v4/articles/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ArticleResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Article> getArticle(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Article>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/v4/articles/${id}/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = Article.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
