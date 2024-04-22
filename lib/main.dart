import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Все новости"),),
        ),
        body: NewsList(),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<dynamic> _news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v3/articles'));

    if (response.statusCode == 200) {
      List<dynamic> newsList = json.decode(response.body);
      setState(() {
        _news = newsList;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _news.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
      itemCount: _news.length * 2 - 1, // увеличиваем количество элементов в два раза и вычитаем 1 для добавления промежутков
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return Divider(); // добавляем виджет Divider между новостями
        }
        final itemIndex = index ~/ 2;
        return ListTile(
          leading: Image.network(_news[itemIndex]['imageUrl'], height: 100, width: 100,),
          title: Text(_news[itemIndex]['title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetail(news: _news[itemIndex]),
              ),
            );
          },
        );
      },
    );
  }
}


class NewsDetail extends StatelessWidget {
  final dynamic news;

  NewsDetail({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(news['imageUrl']),
              SizedBox(height: 8.0),
              Text(news['summary'], style:TextStyle(fontSize: 30)),
              ElevatedButton(
                onPressed: () {
                  _launchURL(Uri.parse(news['url']));
                },
                child: Text('Перейти к источнику',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Функция для открытия URL во внешнем браузере
  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
