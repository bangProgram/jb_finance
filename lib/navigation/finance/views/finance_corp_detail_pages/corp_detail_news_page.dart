import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/commons/widgets/crolling_widget_app.dart';
import 'package:jb_finance/navigation/finance/models/page_models/news_model.dart';
import 'package:jb_finance/navigation/finance/view_models/page_view_models/corp_detail_vm.dart';
import 'package:jb_finance/utils.dart';

class CorpDetailNewsPage extends ConsumerStatefulWidget {
  final String corpCd;
  const CorpDetailNewsPage({super.key, required this.corpCd});

  @override
  ConsumerState<CorpDetailNewsPage> createState() => _CorpDetailNewsPageState();
}

class _CorpDetailNewsPageState extends ConsumerState<CorpDetailNewsPage> {
  void goNaverNews(String officeId, String articleId) async {
    String newsURL = 'https://n.news.naver.com/article/$officeId/$articleId';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CrollingWidgetApp(crollingURL: newsURL),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ref.watch(corpDetailNewsProvider(widget.corpCd)).when(
              error: (error, stackTrace) => Center(
                child: Text('error : $error'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (data) {
                final newsList = data;
                if (newsList != null) {
                  return ListView.separated(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> newsData = newsList[index];
                      final Map<String, dynamic> item = newsData['items'][0];
                      final data = NewsModel.fromJson(item);

                      return ListTile(
                        style: ListTileStyle.list,
                        onTap: () => goNaverNews(data.officeId, data.articleId),
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: data.photoType == 0
                              ? const Center(
                                  child: Icon(Icons.error),
                                )
                              : Image.network(
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
