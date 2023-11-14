import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/navigation/finance/models/news_model.dart';
import 'package:jb_finance/utils.dart';

class CorpDetailNewsPage extends StatefulWidget {
  const CorpDetailNewsPage({super.key});

  @override
  State<CorpDetailNewsPage> createState() => _CorpDetailNewsPageState();
}

class _CorpDetailNewsPageState extends State<CorpDetailNewsPage> {
  @override
  void initState() {
    super.initState();
    getNaverNews();
  }

  Future<dynamic> getNaverNews() async {
    const String newsURL =
        'https://m.stock.naver.com/api/news/stock/005930?pageSize=40&page=1&searchMethod=title_entity_id.basic';
    Uri url = Uri.parse(newsURL);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoonDetail = jsonDecode(response.body);
      return webtoonDetail;
    } else {
      serverMessage(context, '종목 뉴스정보를 가지고오지 못했습니다.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
          future: getNaverNews(),
          builder: (context, snapshot) {
            final newsList = snapshot.data;
            if (newsList != null) {
              return ListView.separated(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> newsData = newsList[index];
                  final Map<String, dynamic> item = newsData['items'][0];
                  final data = NewsModel.fromJson(item);

                  return ListTile(
                    style: ListTileStyle.list,
                    leading: Container(
                      child: Image.network(
                        data.imageOriginLink,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(data.title.replaceAll('&quot;', '"')),
                    subtitle: Text(
                      data.body.replaceAll('&quot;', '"'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              );
            } else {
              return Container(
                child: const Text('뉴스정보가 없습니다'),
              );
            }
          },
        ),
      ),
    );
  }
}
