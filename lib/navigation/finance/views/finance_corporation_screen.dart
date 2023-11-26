import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/commons/repos/util_repo.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_screen.dart';
import 'package:jb_finance/navigation/finance/widgets/customPicker.dart';
import 'package:jb_finance/navigation/finance/widgets/select_account_widget.dart';
import 'package:jb_finance/navigation/finance/widgets/select_date_widget.dart';
import 'package:jb_finance/utils.dart';

class FinanceCorpScreen extends ConsumerStatefulWidget {
  const FinanceCorpScreen({super.key});

  @override
  ConsumerState<FinanceCorpScreen> createState() => _FinanceCorpScreenState();
}

class _FinanceCorpScreenState extends ConsumerState<FinanceCorpScreen>
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

  //세팅 데이터 db기준 년도, 반기
  List<String> yearList = [];
  List<int> halfCntList = [];

  Map<String, dynamic> periodData = {
    'stYear': '',
    'stHalf': null,
    'edYear': '',
    'edHalf': null
  };

  bool isToggle = false;
  bool isMove = false;

  List<String> accountList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_filterHide);
    getYearList();
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

  void _goCorpDetailScreen(String corpNm, String corpCd) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FinanceCorpDetailScreen(corpNm: corpNm, corpCd: corpCd),
      ),
    );
  }

  void getYearList() async {
    final response = await ref.read(utilRepo).getYearList();
    final List<dynamic> data = response['yearList'];

    data.map((e) {
      String bsnsYear = e['BSNS_YEAR'];
      int reprtCnt = e['REPRT_CNT'];

      yearList.add(bsnsYear);
      halfCntList.add(reprtCnt);
      if (periodData['stYear'] == '' && periodData['edYear'] == '') {
        if (reprtCnt == 3) {
          periodData = {
            'stYear': '${int.parse(bsnsYear) - 1}',
            'stHalf': null,
            'edYear': bsnsYear,
            'edHalf': null,
          };
          setState(() {});
        }
      }
    }).toList();
  }

  void setPeriodData(String type, String period, String? value) {
    if (period == 'st') {
      periodData['$period$type'] = value;
    } else {
      periodData['$period$type'] = value;
    }
    print('periodData : $periodData');
  }

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
                                      CustomPicker(
                                        period: 'st',
                                        curData: periodData,
                                        yearList: yearList,
                                        halfCntList: halfCntList,
                                        setPeriodData: setPeriodData,
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
                                      CustomPicker(
                                        period: 'ed',
                                        curData: periodData,
                                        yearList: yearList,
                                        halfCntList: halfCntList,
                                        setPeriodData: setPeriodData,
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
                                    onTap: () => _selectAccount('매출액'),
                                    child: SelectAccountWidget(
                                      thisAccount: '매출액',
                                      accountList: accountList,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectAccount('영업이익'),
                                    child: SelectAccountWidget(
                                      thisAccount: '영업이익',
                                      accountList: accountList,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectAccount('순이익'),
                                    child: SelectAccountWidget(
                                      thisAccount: '순이익',
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
                              onPressed: () {},
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
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final corpNm = '삼성전자_$index';
                      const corpCd = '005930';

                      return GestureDetector(
                        onTap: () => _goCorpDetailScreen(corpNm, corpCd),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            corpNm,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '매출액',
                                                style: TextStyle(
                                                  color: Color(0xFFC4C4C4),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                '3조 9천억',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '영업이익',
                                                style: TextStyle(
                                                  color: Color(0xFFC4C4C4),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                '1조 3천억',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '순이익',
                                                style: TextStyle(
                                                  color: Color(0xFFC4C4C4),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                '3천 3백만',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
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
                  ),
                ),
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
