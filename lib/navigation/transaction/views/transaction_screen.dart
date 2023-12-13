import 'package:flutter/material.dart';
import 'package:jb_finance/navigation/transaction/views/pages/trans_record_page.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int curPage = 0;

  void onTapPageScreen(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '거래일지',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        foregroundColor: const Color(0xFFA8A8A8),
        backgroundColor: Colors.white,
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
              children: [
                Container(
                  color: Colors.amber,
                ),
                const TransRecordPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
