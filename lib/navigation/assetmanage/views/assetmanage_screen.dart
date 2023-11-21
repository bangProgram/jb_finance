import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/widgets/assetmanage_tabbar_header.dart';
import 'package:jb_finance/utils.dart';

class AssetmanageScreen extends ConsumerStatefulWidget {
  const AssetmanageScreen({super.key});

  @override
  ConsumerState<AssetmanageScreen> createState() => _AssetmanageScreenState();
}

class _AssetmanageScreenState extends ConsumerState<AssetmanageScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int curPage = 0;

  List<String> test = [
    '0101',
    '0102',
    '0101',
    '0102',
    '0101',
    '0101',
    '0102',
    '0102',
  ];

  void changePage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => focusOut(context),
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  const SliverAppBar(
                    title: Text('자산관리'),
                    centerTitle: true,
                    elevation: 0,
                    foregroundColor: Color(0xFFA8A8A8),
                    backgroundColor: Colors.transparent,
                  ),
                  SliverToBoxAdapter(
                    child: ref.watch(assetmanageProvider).when(
                          loading: () => Container(),
                          error: (error, stackTrace) => Container(
                            child: Text('error $error'),
                          ),
                          data: (data) {
                            final modelData = data;
                            final totalReturn =
                                (data.evaluationAmount / data.investAmount) *
                                        100 -
                                    100;
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: screenW * 0.01,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: screenW * 0.03,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: screenW * 0.90,
                                              child: Flex(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  const Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text('평가수익률',
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                        '${NumberFormat("#,###.##").format(totalReturn)}%',
                                                        style: TextStyle(
                                                          color: totalReturn > 0
                                                              ? Colors.red
                                                              : Colors.blue,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  const Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text('총평가손익',
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                        '${data.evaluationProfit}',
                                                        style: TextStyle(
                                                          color: totalReturn > 0
                                                              ? Colors.red
                                                              : Colors.blue,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: screenW * 0.90,
                                              child: Flex(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  const Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text('총매입금액',
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                        '${data.investAmount}',
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  const Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text('총평가금액',
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Text(
                                                        '${data.evaluationAmount}',
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => changePage(0),
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
                                '자산평가',
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
                            onTap: () => changePage(1),
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
                  SliverToBoxAdapter(
                    child: curPage == 0
                        ? ref.watch(assetmanageProvider).when(
                              loading: () => Container(),
                              error: (error, stackTrace) => Container(
                                child: Text('error $error'),
                              ),
                              data: (data) {
                                final totalReturn = (data.evaluationAmount /
                                            data.investAmount) *
                                        100 -
                                    100;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: screenW * 0.01,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        '총 수익률',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC4C4C4),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 11,
                                                      ),
                                                      Text(
                                                        '${NumberFormat("#,###.##").format(totalReturn)}%',
                                                        style: TextStyle(
                                                          color: totalReturn > 0
                                                              ? Colors.red
                                                              : Colors.blue,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Text(
                                                        '총 수익',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFC4C4C4),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 11,
                                                      ),
                                                      Text(
                                                        '${data.evaluationProfit}',
                                                        style: TextStyle(
                                                          color: totalReturn > 0
                                                              ? Colors.red
                                                              : Colors.blue,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                        : Container(),
                  )
                ];
              },
              body: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    curPage = value;
                  });
                },
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: 20,
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: screenW * 0.01,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            final portCorpData = index;
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: screenW * 0.015,
                      right: screenW * 0.015,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.calendar,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 30,
                              child: const Text(
                                'ㅡ',
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.calendar,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: screenW * 0.25,
                              alignment: Alignment.center,
                              child: DropdownButton(
                                isExpanded: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                borderRadius: BorderRadius.circular(15),
                                value: null,
                                items: const [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text('전체'),
                                  ),
                                  DropdownMenuItem(
                                    value: '0101',
                                    child: Text('매수'),
                                  ),
                                  DropdownMenuItem(
                                    value: '0102',
                                    child: Text('매도'),
                                  ),
                                ],
                                onChanged: (newValue) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '삼성전자(우)',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: test.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) {
                              final data = test[index];

                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenW * 0.03,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                data == '0101' ? '매수' : '매도',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: data == '0101'
                                                        ? Colors.red
                                                        : Colors.blue),
                                              ),
                                              const Text(
                                                '종목이름',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenW * 0.90,
                                                child: const Flex(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text('거래일자'),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text('23/08/07'),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text('거래금액'),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text('1000000'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: screenW * 0.90,
                                          child: const Flex(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            direction: Axis.horizontal,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: Text('거래수량'),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: Text('100'),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: Text('거래단가'),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                fit: FlexFit.tight,
                                                child: Text('1,000,000'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
