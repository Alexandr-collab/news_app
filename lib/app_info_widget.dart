// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Краткая информация о приложении, его возможностях, контактной информации и т.д.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              launch(
                  'https://github.com/Alexandr-collab/news_app'); // Замените ссылку на ваш репозиторий GitHub
            },
            child: const Text('Ссылка на GitHub'),
          ),
        ],
      ),
    );
  }
}
