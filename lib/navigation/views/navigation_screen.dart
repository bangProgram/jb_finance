import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/navigation/finance/views/finance_screen.dart';
import 'package:jb_finance/navigation/profile/views/portfolio_screen.dart';

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
  final taps = [
    'finance',
    'portfolio',
  ];

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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: CupertinoActionSheet(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: CupertinoActionSheetAction(
                      onPressed: () {
                        context.replace(FinanceScreen.routeURL);
                      },
                      child: const Icon(
                        Icons.home_outlined,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black, // Divider의 색상 설정
                  height: 1, // 높이 조정
                  thickness: 1, // 두께 조정
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: CupertinoActionSheetAction(
                      onPressed: () {
                        context.replace(PortfolioScreen.routeURL);
                      },
                      child: const Icon(
                        Icons.person_outline_outlined,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
