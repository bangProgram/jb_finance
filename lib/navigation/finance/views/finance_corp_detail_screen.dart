import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_info_page.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_news_page.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_report_page.dart';

class FinanceCorpDetailScreen extends StatefulWidget {
  final String corpNm;
  final String corpCode;

  const FinanceCorpDetailScreen({
    super.key,
    required this.corpNm,
    required this.corpCode,
  });

  @override
  State<FinanceCorpDetailScreen> createState() =>
      _FinanceCorpDetailScreenState();
}

class _FinanceCorpDetailScreenState extends State<FinanceCorpDetailScreen> {
  Future<Map<String, dynamic>> getCorpDetail() async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/corp/detail"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'pCorpCode': widget.corpCode}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> resData = json.decode(response.body);
      print('resData1 : $resData');
      return resData;
    } else {
      throw Exception('못가져옴');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: FutureBuilder(
          future: getCorpDetail(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data != null) {
              final clsPrice = data['clsPrice'];
              return Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const FaIcon(
                              Icons.arrow_back_ios_new,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                        ),
                        title: Text(
                          widget.corpNm,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          '기업 업종구분',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              clsPrice == null
                                  ? '73,000'
                                  : '${clsPrice['BEF_CLS_PRICE']}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                            const Text(
                              '*전일종가',
                              style: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    unselectedLabelColor: Colors.black.withOpacity(0.3),
                    tabs: const [
                      Tab(
                        child: Text(
                          '기업정보',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '공시정보',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          '뉴스',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CorpDetailInfoPage(
                            corpDetail: data, corpCd: widget.corpCode),
                        CorpDetailReportPage(corpCd: widget.corpCode),
                        CorpDetailNewsPage(corpCd: widget.corpCode),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
