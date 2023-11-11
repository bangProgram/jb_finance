import 'package:flutter/material.dart';
import 'package:jb_finance/navigation/finance/views/finance_corporation_screen.dart';
import 'package:jb_finance/utils.dart';

class FinanceScreen extends StatefulWidget {
  static const String routeName = "finance";
  static const String routeURL = "/finance";

  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => focusOut(context),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('종목찾기'),
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              tabs: const [
                Tab(
                  child: Text(
                    '전체',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    '관심',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                width: screenW,
                child: const FinanceCorpScreen(),
              ),
              Container(
                color: Colors.amber,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 80,
                      color: Colors.amber.withOpacity(0.5),
                      child: Text('$index 번째 컨테이너'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
