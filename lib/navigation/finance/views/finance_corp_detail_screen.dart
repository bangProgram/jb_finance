import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_pages/corp_detail_info_page.dart';
import 'package:jb_finance/navigation/finance/widgets/fianance_tabbar_header.dart';

class FinanceCorpDetailScreen extends StatefulWidget {
  final String corpNm;
  const FinanceCorpDetailScreen({
    super.key,
    required this.corpNm,
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                elevation: 0,
                foregroundColor: Colors.black,
                backgroundColor: Colors.transparent,
                title: Text('${widget.corpNm} 상세'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.heart,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
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
                    )
                  ],
                ),
              ),
              const SliverPersistentHeader(
                pinned: true,
                delegate: FinanceTabbarHeader(tabList: ['기업정보', '공시정보', '뉴스']),
              ),
            ];
          },
          body: TabBarView(
            children: [
              const CorpDetailInfoPage(),
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
