import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/commons/repos/util_repo.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/interest_vm.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_screen.dart';
import 'package:jb_finance/navigation/finance/widgets/customPicker.dart';
import 'package:jb_finance/navigation/finance/widgets/select_account_widget.dart';
import 'package:jb_finance/utils.dart';

class FinanceInterestScreen extends ConsumerStatefulWidget {
  const FinanceInterestScreen({super.key});

  @override
  ConsumerState<FinanceInterestScreen> createState() =>
      _FinanceInterestScreenState();
}

class _FinanceInterestScreenState extends ConsumerState<FinanceInterestScreen>
    with SingleTickerProviderStateMixin {
  final List<GlobalKey> _containerKeys = List.generate(10, (_) => GlobalKey());
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 400,
    ),
  );

  late final Animation<Offset> _slideAnimation =
      Tween(begin: const Offset(0, 0), end: const Offset(0, -1))
          .animate(_animationController);

  late final Animation<double> _sizeAnimation =
      Tween(begin: 1.0, end: 0.0).animate(_animationController);

  bool isToggle = false;
  bool isMove = false;

  List<String> accountList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_filterHide);
  }

  void _selectAccount(String account) {
    setState(() {
      if (!accountList.contains(account)) {
        accountList.add(account);
      } else {
        accountList.remove(account);
      }
    });
  }

  void _filterHide() {
    var direction = _scrollController.position.userScrollDirection;
    if (isToggle == false && !_animationController.isCompleted) {
      if (direction == ScrollDirection.reverse) {
        _animationController.forward();
        setState(() {
          isToggle = true;
        });
      }
    }
  }

  void _filterShow() {
    if (isToggle == true) {
      _animationController.reverse();
      setState(() {
        isToggle = false;
      });
    }
  }

  void _fliterBtnMove(DragUpdateDetails details) {
    var deltaX = details.delta.dx;
    print('deltaX : $deltaX');
    if (deltaX > 0) {
      isMove = false;
    } else {
      isMove = true;
    }
    setState(() {});
  }

  void _goCorpDetailScreen(String corpNm, String corpCode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FinanceCorpDetailScreen(corpNm: corpNm, corpCode: corpCode),
      ),
    );
  }

  Future<Map<String, dynamic>> getYearList() async {
    final response = await ref.read(utilRepo).getYearList();
    final List<dynamic> data = response['yearList'];

    Map<String, dynamic> result = {};
    //세팅 데이터 db기준 년도, 반기
    List<String> yearList = [];
    List<int> halfCntList = [];
    Map<String, dynamic> periodData = {};

    await Future.forEach(data, (element) {
      String bsnsYear = element['BSNS_YEAR'];
      int reprtCnt = element['REPRT_CNT'];

      yearList.add(bsnsYear);
      halfCntList.add(reprtCnt);
      if (periodData['pStYear'] == null && periodData['pEdYear'] == null) {
        if (reprtCnt == 3) {
          periodData['pStYear'] = '${int.parse(bsnsYear) - 1}';
          periodData['pStHalf'] = null;
          periodData['pEdYear'] = bsnsYear;
          periodData['pEdHalf'] = null;
        }
      }
    });

    result['yearList'] = yearList;
    result['halfCntList'] = halfCntList;
    result['periodData'] = periodData;

    return result;
  }

  void setPeriodData(String type, String period, String? value) {
    if (period == 'St') {
      print('$period $type $value');
    } else {
      print('$period $type $value');
    }
  }

  void selectCorpList() {}

  @override
  void dispose() {
    print('finance Corporation Screen dispose !!!!');
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
        body: NestedScrollView(
      scrollBehavior: MyCustomScrollBehavior(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: SizeTransition(
                sizeFactor: _sizeAnimation,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 14,
                    right: 14,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '기간',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder(
                                        future: getYearList(),
                                        builder: (context, snapshot) {
                                          final result = snapshot.data;
                                          if (result != null) {
                                            final yearList = result['yearList'];
                                            final halfCntList =
                                                result['halfCntList'];
                                            final periodData =
                                                result['periodData'];

                                            return CustomPicker(
                                              period: 'St',
                                              curData: periodData,
                                              yearList: yearList,
                                              halfCntList: halfCntList,
                                              setPeriodData: setPeriodData,
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    child: const Text(
                                      '~',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      FutureBuilder(
                                        future: getYearList(),
                                        builder: (context, snapshot) {
                                          final result = snapshot.data;
                                          if (result != null) {
                                            final yearList = result['yearList'];
                                            final halfCntList =
                                                result['halfCntList'];
                                            final periodData =
                                                result['periodData'];

                                            return CustomPicker(
                                              period: 'Ed',
                                              curData: periodData,
                                              yearList: yearList,
                                              halfCntList: halfCntList,
                                              setPeriodData: setPeriodData,
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '구분',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _selectAccount('pAvgType1'),
                                    child: SelectAccountWidget(
                                      text: '매출액',
                                      thisAccount: 'pAvgType1',
                                      accountList: accountList,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectAccount('pAvgType2'),
                                    child: SelectAccountWidget(
                                      text: '영업이익',
                                      thisAccount: 'pAvgType2',
                                      accountList: accountList,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectAccount('pAvgType3'),
                                    child: SelectAccountWidget(
                                      text: '순이익',
                                      thisAccount: 'pAvgType3',
                                      accountList: accountList,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectAccount('pAvgType4'),
                                    child: SelectAccountWidget(
                                      text: 'EPS',
                                      thisAccount: 'pAvgType4',
                                      accountList: accountList,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '성장률',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 38,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFEFEFEF),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            '이상',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: selectCorpList,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors.transparent;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(
                                      color: Color(0xffE9E9EC),
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                '조회하기',
                                style: TextStyle(
                                  color: Color(0xff444447),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '* 최근 1년 기준',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: SizedBox(
        width: screenW,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: ref.watch(interProvider).when(
                          error: (error, stackTrace) {
                            return Center(
                              child: Text('$error'),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          data: (data) {
                            final corpList = data;
                            return ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: corpList.length,
                              itemBuilder: (context, index) {
                                final corpData = corpList[index];

                                return GestureDetector(
                                  onTap: () => _goCorpDetailScreen(
                                      corpData.corpName, corpData.corpCode),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 15,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFFEFEFEF),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          radius: 35,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      corpData.corpName,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons.heart,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const FractionallySizedBox(
                                                widthFactor: 0.9,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '매출액',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          '3조 9천억',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '영업이익',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          '1조 3천억',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '순이익',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          '3천 3백만',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )),
              ],
            ),
            if (isToggle)
              Positioned(
                top: 15,
                right: isMove ? screenW - 50 - 15 : 15,
                child: GestureDetector(
                  onTap: _filterShow,
                  onHorizontalDragUpdate: (details) {
                    _fliterBtnMove(details);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '확장',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
