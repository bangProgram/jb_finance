import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/interest_vm.dart';
import 'package:jb_finance/navigation/finance/views/finance_corporation_screen.dart';
import 'package:jb_finance/navigation/finance/views/finance_interest_screen.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';
import 'package:jb_finance/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  static const String routeName = "finance";
  static const String routeURL = "/finance";

  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  late SharedPreferences prefs;

  int screenIndex = 0;

  List<String> interList = [];
  List<String> tradeList = [];

  @override
  void initState() {
    super.initState();
    initInter();
    initTrade();
  }

  void initInter() async {
    final initInterData =
        await ref.read(interProvider.notifier).initinterList();
    int initInterCnt = initInterData['initCnt'];
    if (initInterCnt > 0) {
      final List<dynamic> initInterList = initInterData['initList'];
      initInterList.map((data) {
        interList.add('${data['STOCK_CODE']}');
      }).toList();
    }
  }

  void initTrade() async {
    final initTradeData =
        await ref.read(tradeCorpListProvider.notifier).initTradeList();
    int initTradeCnt = initTradeData['initCnt'];
    if (initTradeCnt > 0) {
      final List<dynamic> initTradeList = initTradeData['initList'];
      initTradeList.map((data) {
        tradeList.add('${data['STOCK_CODE']}');
      }).toList();
    }
  }

  void onTapCorpScreen(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  Future<void> toggleInterest(String flag, String corpCode) async {
    if (flag == 'del') {
      if (tradeList.contains(corpCode)) {
        serverMessage(context, '거래일지로 등록이 되어있는 종목은 삭제할 수 없습니다');
        return;
      } else {
        interList.remove(corpCode);
        await ref
            .read(interProvider.notifier)
            .delInterest({'STOCK_CODE': corpCode});
      }
    } else {
      interList.add(corpCode);
      await ref
          .read(interProvider.notifier)
          .addInterest({'STOCK_CODE': corpCode});
    }

    setState(() {});
  }

  Future<void> toggleTrade(String flag, String corpCode) async {
    if (flag == 'del') {
      tradeList.remove(corpCode);
      await ref
          .read(tradeCorpListProvider.notifier)
          .delTrade({'pStockCode': corpCode});
    } else {
      tradeList.add(corpCode);
      await ref
          .read(tradeCorpListProvider.notifier)
          .addTrade({'pStockCode': corpCode});

      if (interList.contains(corpCode)) {
        return;
      } else {
        print('관심기업도 등록한다');
        await toggleInterest(flag, corpCode);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => focusOut(context),
        child: Scaffold(
          appBar: AppBar(
            title: SvgPicture.asset('assets/svgs/logos/Logo_app_main.svg'),
            elevation: 1,
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onTapCorpScreen(0),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: screenIndex == 0
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              '전체',
                              style: TextStyle(
                                color: screenIndex == 0
                                    ? Colors.black
                                    : const Color(0xFFE6E6E6),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onTapCorpScreen(1),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: screenIndex == 1
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              '관심',
                              style: TextStyle(
                                color: screenIndex == 1
                                    ? Colors.black
                                    : const Color(0xFFE6E6E6),
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
              ),
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Offstage(
                        offstage: screenIndex != 0,
                        child: FinanceCorpScreen(
                            interList: interList,
                            toggleInterest: toggleInterest,
                            tradeList: tradeList,
                            toggleTrade: toggleTrade),
                      ),
                      Offstage(
                        offstage: screenIndex != 1,
                        child: FinanceInterestScreen(
                            interList: interList,
                            toggleInterest: toggleInterest,
                            tradeList: tradeList,
                            toggleTrade: toggleTrade),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
