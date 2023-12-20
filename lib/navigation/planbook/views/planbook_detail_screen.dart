import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';
import 'package:jb_finance/navigation/planbook/views/pages/plan_detail_info_page.dart';
import 'package:jb_finance/navigation/planbook/views/pages/plan_detail_memo_page.dart';
import 'package:jb_finance/utils.dart';

class PlanbookDetailScreen extends ConsumerStatefulWidget {
  final String corpCode;
  final String stockCode;
  final String corpName;
  final int befClsPrice;
  final String? periodGubn;

  const PlanbookDetailScreen({
    super.key,
    required this.corpCode,
    required this.stockCode,
    required this.corpName,
    required this.befClsPrice,
    required this.periodGubn,
  });

  @override
  ConsumerState<PlanbookDetailScreen> createState() =>
      _PlanbookDetailScreenState();
}

class _PlanbookDetailScreenState extends ConsumerState<PlanbookDetailScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  int curPage = 0;

  void pageChange(int index) {
    setState(() {
      curPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
        body: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(
                    widget.corpName,
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
                        NumberFormat('#,###').format(widget.befClsPrice),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        '*전일 종가',
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                  color: Color(0xffe6e6e6),
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pageChange(0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: curPage == 0
                                      ? const Color(0xff333333)
                                      : const Color(0xffE6E6E6),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              '상태',
                              style: TextStyle(
                                color: curPage == 0
                                    ? const Color(0xff333333)
                                    : const Color(0xffE6E6E6),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pageChange(1),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: curPage == 1
                                      ? const Color(0xff333333)
                                      : const Color(0xffE6E6E6),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              '기록',
                              style: TextStyle(
                                color: curPage == 1
                                    ? const Color(0xff333333)
                                    : const Color(0xffE6E6E6),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
                  PlanDetailInfoPage(
                    corpCode: widget.corpCode,
                    stockCode: widget.stockCode,
                    befClsPrice: widget.befClsPrice,
                    periodGubn: widget.periodGubn,
                  ),
                  PlanDetailMemoPage(
                    corpCode: widget.corpCode,
                    periodGubn: widget.periodGubn,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
