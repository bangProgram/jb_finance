import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/commons/repos/util_repo.dart';
import 'package:jb_finance/navigation/finance/repos/interest_repo.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/interest_vm.dart';
import 'package:jb_finance/navigation/finance/views/finance_corp_detail_screen.dart';
import 'package:jb_finance/navigation/finance/widgets/customPicker.dart';
import 'package:jb_finance/navigation/finance/widgets/select_account_widget.dart';
import 'package:jb_finance/navigation/finance/widgets/select_date_widget.dart';
import 'package:jb_finance/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  late final Animation<Offset> _slideAnimation =
      Tween(begin: const Offset(0, 0), end: const Offset(0, -1))
          .animate(_animationController);

  late final Animation<double> _sizeAnimation =
      Tween(begin: 1.0, end: 0.0).animate(_animationController);

  bool isToggle = false;
  bool isMove = false;

  List<String> accountList = [];

  List<String> interList = [];

  String stYear = '';
  String stHalf = '';
  String edYear = '';
  String edHalf = '';

  final Map<String, dynamic> _searchModel = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_filterHide);
    initPreference();
  }

  void initPreference() async {
    prefs = await _prefs;
    final prefsData = prefs.getStringList('interList');
    if (prefsData != null) {
      setState(() {
        interList.addAll(prefsData);
      });
    }
  }

  void _selectAccount(String account) {
    setState(() {
      if (!accountList.contains(account)) {
        accountList.add(account);
        _searchModel[account] = true;
      } else {
        accountList.remove(account);
        _searchModel[account] = null;
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

    await Future.forEach(data, (element) {
      String bsnsYear = element['BSNS_YEAR'];
      int reprtCnt = element['REPRT_CNT'];

      yearList.add(bsnsYear);
      halfCntList.add(reprtCnt);
      if (_searchModel['pStYear'] == null && _searchModel['pEdYear'] == null) {
        if (reprtCnt == 3) {
          _searchModel['pStYear'] = '${int.parse(bsnsYear) - 1}';
          _searchModel['pStHalf'] = null;
          _searchModel['pEdYear'] = bsnsYear;
          _searchModel['pEdHalf'] = null;
        }
      }
    });

    result['yearList'] = yearList;
    result['halfCntList'] = halfCntList;
    result['periodData'] = _searchModel;

    return result;
  }

  void setPeriodData(String type, String period, String? value) {
    if (period == 'St') {
      if (type == 'Year') {
        _searchModel['pStYear'] = value;
      } else {
        _searchModel['pStHalf'] = value;
      }
    } else {
      if (type == 'Year') {
        _searchModel['pEdYear'] = value;
      } else {
        _searchModel['pEdHalf'] = value;
      }
    }
  }

  void selectCorpList() async {
    _searchModel['searchType'] = 'year';
    if (_searchModel['pStHalf'] != null) {
      if (_searchModel['pEdHalf'] == null) {
        serverMessage(context, '종료 반기 조회기간을 확인해주세요.');
        return;
      }
      _searchModel['searchType'] = 'half';
    } else if (_searchModel['pEdHalf'] != null) {
      if (_searchModel['pStHalf'] == null) {
        serverMessage(context, '시작 반기 조회기간을 확인해주세요.');
        return;
      }
      _searchModel['searchType'] = 'half';
    }

    print('_searchModel : $_searchModel');
    await ref.read(interProvider.notifier).getCorpList(param: _searchModel);
    focusOut(context);
  }

  void toggleInterest(String flag, String corpCode) async {
    if (flag == 'del') {
      interList.remove(corpCode);
      ref.read(interProvider.notifier).delInterest({'STOCK_CODE': corpCode});
    } else {
      interList.add(corpCode);
      ref.read(interProvider.notifier).addInterest({'STOCK_CODE': corpCode});
    }

    setState(() {});
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
                                  /* 
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
                                   */
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
                            child: TextField(
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (value) {
                                  _searchModel['pAvgValue'] = value;
                                }),
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
                          Container(
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              '기업명',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
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
                              child: TextField(
                                maxLength: 15,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (value) {
                                  _searchModel['pCorpName'] = value;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
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
                            '*조회기간 : $stYear $stHalf ~ $edYear $edHalf',
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
            Positioned.fill(
              child: ref.watch(interProvider).when(
                    error: (error, stackTrace) {
                      return Center(
                        child: Text('에러? $error'),
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    data: (data) {
                      final corpList = data;
                      stYear = data.first.stYear!;
                      edYear = data.first.edYear!;
                      stHalf = data.first.stHalf ?? '';
                      edHalf = data.first.edHalf ?? '';

                      return corpList.first.corpName == ""
                          ? const Center(
                              child: Text('만족하는 사업장이 없습니다'),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: corpList.length,
                              itemBuilder: (context, index) {
                                final corpData = corpList[index];
                                final interCorpCode = corpData.isInterest;
                                if (interCorpCode != null) {
                                  interList.add(interCorpCode);
                                }

                                return GestureDetector(
                                  onTap: () => _goCorpDetailScreen(
                                      corpData.corpName, corpData.corpCode),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFFFFF),
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
                                          radius: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
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
                                                    icon: SvgPicture.asset(
                                                      'assets/svgs/icons/Icon_money_inact.svg',
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        toggleInterest(
                                                            interList.contains(
                                                                    corpData
                                                                        .corpCode)
                                                                ? 'del'
                                                                : 'add',
                                                            corpData.corpCode),
                                                    icon: SvgPicture.asset(
                                                      interList.contains(
                                                              corpData.corpCode)
                                                          ? 'assets/svgs/icons/Icon_heart_act.svg'
                                                          : 'assets/svgs/icons/Icon_heart_inact.svg',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          '매출액',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.curAmount1 ==
                                                                  null
                                                              ? '적자'
                                                              : amountTrans(corpData
                                                                  .curAmount1!),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.avgAmount1 ==
                                                                  null
                                                              ? '적자'
                                                              : '${corpData.avgAmount1} %',
                                                          style: TextStyle(
                                                            color: corpData
                                                                        .avgAmount1 ==
                                                                    null
                                                                ? Colors.black
                                                                : corpData.avgAmount1 >
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          '영업이익',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.curAmount2 ==
                                                                  null
                                                              ? '적자'
                                                              : amountTrans(corpData
                                                                  .curAmount2!),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.avgAmount2 ==
                                                                  null
                                                              ? '적자'
                                                              : '${corpData.avgAmount2} %',
                                                          style: TextStyle(
                                                            color: corpData
                                                                        .avgAmount2 ==
                                                                    null
                                                                ? Colors.black
                                                                : corpData.avgAmount2 >
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          '순이익',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.curAmount3 ==
                                                                  null
                                                              ? '적자'
                                                              : amountTrans(corpData
                                                                  .curAmount3!),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          corpData.avgAmount3 ==
                                                                  null
                                                              ? '적자'
                                                              : '${corpData.avgAmount3} %',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            color: corpData
                                                                        .avgAmount3 ==
                                                                    null
                                                                ? Colors.black
                                                                : corpData.avgAmount3 >
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                  ),
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
