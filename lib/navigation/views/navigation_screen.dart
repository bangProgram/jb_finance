import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/navigation/assetmanage/views/assetmanage_screen.dart';
import 'package:jb_finance/navigation/finance/views/finance_screen.dart';
import 'package:jb_finance/navigation/planbook/views/planbook_screen.dart';
import 'package:jb_finance/navigation/setting/views/setting_screen.dart';
import 'package:jb_finance/navigation/trade/views/trade_screen.dart';
import 'package:jb_finance/utils.dart';

class NavigationScreen extends StatefulWidget {
  static const String routeName = "navigation";
  static const String routeURL = "/finance";

  final String tap;

  const NavigationScreen({super.key, required this.tap});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  final taps = ['finance', 'planbook', 'portfolio', 'setting'];
  int curPage = 0;
  final List<Widget> page = [
    const FinanceScreen(),
    const PlanbookScreen(),
    const TradeScreen(),
    const AssetmanageScreen(),
  ];

  void goNavigationScreen(int index) async {
    final url = '/${taps[index]}';
    print('url : $url / ${url.contains('setting')}');
    _pageController.jumpToPage(index);
    context.replace(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return page[index];
          },
        ),
/* 
            Stack(
          children: [
            Offstage(
              offstage: taps.indexOf(widget.tap) != 0,
              child: const FinanceScreen(),
            ),
            Offstage(
              offstage: taps.indexOf(widget.tap) != 1,
              child: const PlanbookScreen(),
            ),
            Offstage(
              offstage: taps.indexOf(widget.tap) != 2,
              child: const TradeScreen(),
            ),
            Offstage(
              offstage: taps.indexOf(widget.tap) != 3,
              child: const AssetmanageScreen(),
            ),
          ],
        ),
 */
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.white,
          child: BottomNavigationBar(
            elevation: 0,
            iconSize: 20,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.blue,
            onTap: (index) {
              goNavigationScreen(index);
            },
            currentIndex: taps.indexOf(widget.tap),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.chartLine),
                label: '종목',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.flag),
                label: '목표관리',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.wonSign),
                label: '거래일지',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                label: '포트폴리오',
              ),
            ],
          ),
          // CupertinoActionSheet(

          //   actions: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Expanded(
          //           child: Container(
          //             color: Colors.transparent,
          //             child: CupertinoActionSheetAction(
          //               onPressed: () {
          //                 context.replace(FinanceScreen.routeURL);
          //               },
          //               child: const Icon(FontAwesomeIcons.house),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           height: 30,
          //           decoration: BoxDecoration(border: Border.all()), // 두께 조정
          //         ),
          //         Expanded(
          //           child: Container(
          //             color: Colors.transparent,
          //             child: CupertinoActionSheetAction(
          //               onPressed: () {
          //                 context.replace(PortfolioScreen.routeURL);
          //               },
          //               child: const Icon(FontAwesomeIcons.solidUser),
          //             ),
          //           ),
          //         ),
          //         const Divider(
          //           color: Colors.black, // Divider의 색상 설정
          //           height: 1, // 높이 조정
          //           thickness: 1, // 두께 조정
          //         ),
          //         Expanded(
          //           child: Container(
          //             color: Colors.transparent,
          //             child: CupertinoActionSheetAction(
          //               onPressed: () {
          //                 context.replace(PortfolioScreen.routeURL);
          //               },
          //               child: const Icon(
          //                 FontAwesomeIcons.gear,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
