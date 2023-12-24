import 'package:flutter/material.dart';
import 'package:jb_finance/navigation/trade/views/pages/trade_corp_page.dart';
import 'package:jb_finance/navigation/trade/views/pages/trade_record_page.dart';
import 'package:jb_finance/utils.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int curPage = 0;

  void onTapPageScreen(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '거래일지',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          foregroundColor: const Color(0xFFA8A8A8),
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA8A8A8),
              width: 0.8,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: curPage == 0
                              ? const Color(0xFF333333)
                              : const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '기업목록',
                          style: TextStyle(
                            color: curPage == 0
                                ? Colors.white
                                : const Color(0xFFB1B1B1),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(1),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: curPage == 1
                              ? const Color(0xFF333333)
                              : const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '거래내역',
                          style: TextStyle(
                            color: curPage == 1
                                ? Colors.white
                                : const Color(0xFFB1B1B1),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    curPage = value;
                  });
                },
                children: const [
                  TradeCorpPage(),
                  TradeRecordPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
