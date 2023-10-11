import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/navigation/finance/views/finance_screen.dart';
import 'package:jb_finance/navigation/portfolio/views/portfolio_screen.dart';
import 'package:jb_finance/navigation/setting/views/setting_screen.dart';

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
  final taps = ['finance', 'portfolio', 'setting'];

  void goNavigationScreen(int index) {
    final url = '/${taps[index]}';
    print('url : $url');
    context.replace(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: taps.indexOf(widget.tap) != 0,
            child: const FinanceScreen(),
          ),
          Offstage(
            offstage: taps.indexOf(widget.tap) != 1,
            child: const PortfolioScreen(),
          ),
          Offstage(
            offstage: taps.indexOf(widget.tap) != 2,
            child: const SettingScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          elevation: 0,
          iconSize: 20,
          onTap: (index) {
            goNavigationScreen(index);
          },
          currentIndex: taps.indexOf(widget.tap),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house),
              label: '종목',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUser),
              label: '포트폴리오',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear),
              label: '설정',
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
    );
  }
}