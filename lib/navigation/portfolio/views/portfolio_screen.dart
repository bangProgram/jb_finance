import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/portfolio/models/portfolio_model.dart';
import 'package:jb_finance/navigation/portfolio/view_models/portfolio_vm.dart';
import 'package:jb_finance/navigation/portfolio/views/portfolio_edit_screen.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_corp_tab_widget.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_widget.dart';
import 'package:jb_finance/navigation/portfolio/widgets/portfolio_tabbar_header.dart';
import 'package:jb_finance/utils.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  static const String routeName = "portfolio";
  static const String routeURL = "/portfolio";

  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  late final TextEditingController _startDtController =
      TextEditingController(text: '$startYear/$startMonth/$startDay');
  late final TextEditingController _endDtController =
      TextEditingController(text: '$endYear/$endMonth/$endDay');
  late PortfolioModel _modelData;

  DateTime now = DateTime.now();
  late int startYear = now.year; // 년도 추출
  late int startMonth = now.month; // 월 추출 (1부터 12까지)
  late int startDay = now.day;

  late DateTime oneMonthlater = now.add(const Duration(days: 30));

  late int endYear = oneMonthlater.year;
  late int endMonth = oneMonthlater.month;
  late int endDay = oneMonthlater.day;

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

  String? selectedGubn;
  double valPadding = 8.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      print('offset : $offset');
      if (offset > 382) {
        setState(() {
          valPadding = (offset - 382.0);
        });
      } else {
        if (valPadding != 8.0) {
          setState(() {
            valPadding = 8.0;
          });
        }
      }
    });
  }

  void goPortfolioEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PortfolioEditScreen(data: _modelData),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateFormat format = DateFormat('yyyy/MM/dd');

    final picked = await showDatePicker(
      context: context,
      initialDate: format.parse(controller.text),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != now) {
      setState(() {
        int year = picked.year;
        int month = picked.month;
        int day = picked.day;

        controller.text =
            '$year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  void dispose() {
    _startDtController.dispose();
    _endDtController.dispose();
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
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: const Text('포트폴리오'),
                    centerTitle: true,
                    elevation: 0,
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        onPressed: goPortfolioEdit,
                        icon: const FaIcon(
                          FontAwesomeIcons.penToSquare,
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: ref.watch(portfolioProvider).when(
                          loading: () => PortfolioWidget(
                            data: PortfolioModel.empty(),
                            size: screenW / 2,
                          ),
                          error: (error, stackTrace) => Container(
                            child: Text('error $error'),
                          ),
                          data: (data) {
                            _modelData = data;
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
                                  PortfolioWidget(
                                    data: data,
                                    size: screenW / 2,
                                  ),
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
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PortfolioTabbarHeader(),
                  ),
                ];
              },
              body: TabBarView(
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
                            return PortfolioCorpTabWidget(screenW: screenW);
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: screenW * 0.015,
                      right: screenW * 0.015,
                      top: valPadding,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _selectDate(context, _startDtController),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _startDtController,
                                          enabled: false,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const FaIcon(
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
                                onTap: () =>
                                    _selectDate(context, _endDtController),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _endDtController,
                                          enabled: false,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const FaIcon(
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
                                value: selectedGubn,
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
                                  setState(() {
                                    selectedGubn = newValue;
                                  });
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
