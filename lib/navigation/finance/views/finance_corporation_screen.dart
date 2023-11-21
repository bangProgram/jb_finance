import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_screen.dart';
import 'package:jb_finance/navigation/finance/widgets/select_account_widget.dart';
import 'package:jb_finance/navigation/finance/widgets/select_date_widget.dart';
import 'package:jb_finance/utils.dart';

class FinanceCorpScreen extends StatefulWidget {
  const FinanceCorpScreen({super.key});

  @override
  State<FinanceCorpScreen> createState() => _FinanceCorpScreenState();
}

class _FinanceCorpScreenState extends State<FinanceCorpScreen>
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

  int diffCnt = 0;
  String selType = "";

  bool isToggle = false;
  bool isMove = false;

  List<String> accountList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_filterHide);
  }

  void _selectDate(int diff, String type) async {
    setState(() {
      if (diffCnt == diff && selType == type) {
        diffCnt = 0;
        selType = "";
      } else {
        diffCnt = diff;
        selType = type;
      }
    });
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
                              '년도',
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
                                    onTap: () => _selectDate(3, "년"),
                                    child: SelectDateWidget(
                                        type: '년',
                                        thisCnt: 3,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(5, "년"),
                                    child: SelectDateWidget(
                                        type: '년',
                                        thisCnt: 5,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(7, "년"),
                                    child: SelectDateWidget(
                                        type: '년',
                                        thisCnt: 7,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(9, "년"),
                                    child: SelectDateWidget(
                                        type: '년',
                                        thisCnt: 9,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(10, "년"),
                                    child: SelectDateWidget(
                                        type: '년',
                                        thisCnt: 10,
                                        diffCnt: diffCnt,
                                        selType: selType),
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
                              '반기',
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
                                    onTap: () => _selectDate(3, "반기"),
                                    child: SelectDateWidget(
                                        type: '반기',
                                        thisCnt: 3,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(5, "반기"),
                                    child: SelectDateWidget(
                                        type: '반기',
                                        thisCnt: 5,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(7, "반기"),
                                    child: SelectDateWidget(
                                        type: '반기',
                                        thisCnt: 7,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(9, "반기"),
                                    child: SelectDateWidget(
                                        type: '반기',
                                        thisCnt: 9,
                                        diffCnt: diffCnt,
                                        selType: selType),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () => _selectDate(10, "반기"),
                                    child: SelectDateWidget(
                                        type: '반기',
                                        thisCnt: 10,
                                        diffCnt: diffCnt,
                                        selType: selType),
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
                          SizedBox(
                            width: 100,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '직접입력(%)',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
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
                              onPressed: () {
                                // 클릭 시 동작
                              },
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
                                    borderRadius: BorderRadius.circular(4),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                '조회',
                                style: TextStyle(color: Colors.black),
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
                      const Divider(
                        color: Colors.grey,
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
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 0,
                      );
                    },
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
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFEFEFEF),
                              width: 1,
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
