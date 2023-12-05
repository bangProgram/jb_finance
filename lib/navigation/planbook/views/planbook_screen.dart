import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/planbook/views/pages/planbook_list_page.dart';
import 'package:jb_finance/navigation/planbook/widgets/planbook_tabbar_header.dart';

class PlanbookScreen extends ConsumerStatefulWidget {
  static const String routeName = "planbook";
  static const String routeURL = "/planbook";

  const PlanbookScreen({super.key});

  @override
  ConsumerState<PlanbookScreen> createState() => _PlanbookScreenState();
}

class _PlanbookScreenState extends ConsumerState<PlanbookScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int curIndex = 0;

  String headerData = "";

  void onTapPageScreen(int index) {
    setState(() {
      curIndex = index;
      _pageController.jumpToPage(index);
/* 
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
  */
    });
    print('index : $index');
  }

  @override
  void dispose() {
    print('planbook Dispose !!!!!!!!!');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text(
          '목표관리',
          style: TextStyle(
            color: Color(0xffA8A8A8),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              height: 55,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xffe0e0e0),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(0),
                      child: PlanbookTabWidget(
                        curIndex: curIndex,
                        isSelect: curIndex == 0,
                        text: '미정',
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Color(0xffe0e0e0),
                    width: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(1),
                      child: PlanbookTabWidget(
                        curIndex: curIndex,
                        isSelect: curIndex == 1,
                        text: '단기',
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Color(0xffe0e0e0),
                    width: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(2),
                      child: PlanbookTabWidget(
                        curIndex: curIndex,
                        isSelect: curIndex == 2,
                        text: '중기',
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Color(0xffe0e0e0),
                    width: 1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapPageScreen(3),
                      child: PlanbookTabWidget(
                        curIndex: curIndex,
                        isSelect: curIndex == 3,
                        text: '장기',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      curIndex = value;
                    });
                  },
                  children: const [
                    PlanbookListPage(index: 0),
                    PlanbookListPage(index: 1),
                    PlanbookListPage(index: 2),
                    PlanbookListPage(index: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanbookTabWidget extends StatelessWidget {
  final bool isSelect;
  final int curIndex;
  final String text;

  const PlanbookTabWidget({
    super.key,
    required this.curIndex,
    required this.isSelect,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelect ? const Color(0xff333333) : Colors.transparent,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12.5),
      child: Text(
        text,
        style: TextStyle(
          color: isSelect ? Colors.white : const Color(0xffA8A8A8),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
