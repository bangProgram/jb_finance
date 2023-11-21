import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_info_page.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_news_page.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_report_page.dart';

class FinanceCorpDetailScreen extends StatefulWidget {
  final String corpNm;
  final String corpCd;

  const FinanceCorpDetailScreen({
    super.key,
    required this.corpNm,
    required this.corpCd,
  });

  @override
  State<FinanceCorpDetailScreen> createState() =>
      _FinanceCorpDetailScreenState();
}

class _FinanceCorpDetailScreenState extends State<FinanceCorpDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
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
                  trailing: const Text(
                    '73,210원',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
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
                  CorpDetailInfoPage(corpCd: widget.corpCd),
                  CorpDetailReportPage(corpCd: widget.corpCd),
                  CorpDetailNewsPage(corpCd: widget.corpCd),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
