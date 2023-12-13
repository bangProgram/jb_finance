import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/assetmanage/views/pages/aseetmanage_list_page.dart';
import 'package:jb_finance/navigation/assetmanage/views/pages/aseetmanage_proportion_page.dart';
import 'package:jb_finance/navigation/assetmanage/views/pages/assetmanage_record_page.dart';
import 'package:jb_finance/utils.dart';

class AssetmanageScreen extends ConsumerStatefulWidget {
  const AssetmanageScreen({super.key});

  @override
  ConsumerState<AssetmanageScreen> createState() => _AssetmanageScreenState();
}

class _AssetmanageScreenState extends ConsumerState<AssetmanageScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int curPage = 0;

  DateTime now = DateTime.now();
  //서버단 parameter
  late DateTime stDate = DateTime(now.year, now.month, 1);
  late DateTime edDate = now;
  String? pGubn;

  late String stDateStr = '${stDate.year}. ${stDate.month}. ${stDate.day}';
  late String edDateStr = '${edDate.year}. ${edDate.month}. ${edDate.day}';

  late Map<String, dynamic> searchParam = {
    'pStDate': DateFormat('yyyyMMdd').format(stDate).toString(),
    'pEdDate': DateFormat('yyyyMMdd').format(edDate).toString(),
    'pGubn': '',
    'pCorpName': '',
  };

  Map<String, dynamic> formData = {};

  void onTapPageScreen(int page) {
    _pageController.jumpToPage(page);
  }

  Future<void> _selectDate(BuildContext context, String flag) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: flag == 'st' ? stDate : edDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (flag == 'st') {
          stDate = picked;
          searchParam['pStDate'] =
              DateFormat('yyyyMMdd').format(stDate).toString();
          stDateStr = '${picked.year}. ${picked.month}. ${picked.day}';
        } else {
          edDate = picked;
          searchParam['pEdDate'] =
              DateFormat('yyyyMMdd').format(edDate).toString();
          edDateStr = '${picked.year}. ${picked.month}. ${picked.day}';
        }
      });
    }
  }

  void _selectGubn(String? gubn) {
    setState(() {
      pGubn = gubn;
    });
  }

  void getAssetRecord() async {
    print('param : $searchParam');

    await ref.read(assetRecordProvider.notifier).getAssetRecord(searchParam);
  }

  void mergePortfolio() {
    final state = _formKey.currentState;
    focusOut(context);
    if (state != null) {
      state.save();
      ref
          .read(assetmanageProvider.notifier)
          .mergeAssetAmount(context, formData);
    }
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
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: GestureDetector(
            onTap: () => focusOut(context),
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    const SliverAppBar(
                      title: Text(
                        '자산관리',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      centerTitle: true,
                      elevation: 1,
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
                              int totalAmount = data.depositAmount +
                                  data.investAmount +
                                  data.reserveAmount;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Color(0xFFF4F4F4),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            '나의 자산',
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: mergePortfolio,
                                            child: const Text('저장')),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: totalAmount == 0
                                                  ? Container(
                                                      height: 50,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffE7E7E7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 50,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Flex(
                                                        direction:
                                                            Axis.horizontal,
                                                        children: [
                                                          Flexible(
                                                            flex: ((data.investAmount /
                                                                        totalAmount) *
                                                                    100)
                                                                .round(),
                                                            child: Container(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: ((data.depositAmount /
                                                                        totalAmount) *
                                                                    100)
                                                                .round(),
                                                            child: Container(
                                                              color: const Color(
                                                                  0xffFFC84D),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: ((data.reserveAmount /
                                                                        totalAmount) *
                                                                    100)
                                                                .round(),
                                                            child: Container(
                                                              color: const Color(
                                                                  0xFF2DB400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 17,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  initialValue:
                                                      '${data.investAmount}',
                                                  enabled: false,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                      top: 0,
                                                      bottom: 0,
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  initialValue:
                                                      '${data.depositAmount}',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                      top: 0,
                                                      bottom: 0,
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  onSaved: (newValue) {
                                                    formData['depositAmount'] =
                                                        newValue ?? '0';
                                                  },
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 1,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  initialValue:
                                                      '${data.reserveAmount}',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                      top: 0,
                                                      bottom: 0,
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  onSaved: (newValue) {
                                                    formData['reserveAmount'] =
                                                        newValue ?? '0';
                                                  },
                                                ),
                                              ),
                                              /*  20231212 기존 투자금 텍스트 위젯
                                              Row(
                                                children: [
                                                  const Text(
                                                    '투자금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    NumberFormat("#,###")
                                                        .format(data.investAmount),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    '예수금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    NumberFormat("#,###")
                                                        .format(data.depositAmount),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    '예비금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    NumberFormat("#,###")
                                                        .format(data.reserveAmount),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                             */
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Text(
                                                    '투자금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.yellow,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Text(
                                                    '예수금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xff2DB400),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  const Text(
                                                    '예비금',
                                                    style: TextStyle(
                                                      color: Color(0xFFA8A8A8),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 19,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              '총액',
                                              style: TextStyle(
                                                color: Color(0xFFA8A8A8),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              NumberFormat("#,###")
                                                  .format(totalAmount),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    height: 50,
                                    thickness: 8,
                                    color: Color(0xFFF4F4F4),
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onTapPageScreen(0),
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
                              onTap: () => onTapPageScreen(1),
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
                                  '자산비중',
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
                                    final totalReturn = data.investAmount > 0
                                        ? (data.evaluationAmount /
                                                    data.investAmount) *
                                                100 -
                                            100
                                        : 0;
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 11,
                                                        ),
                                                        Text(
                                                          totalReturn != 0
                                                              ? '${NumberFormat("#,###.##").format(totalReturn)}%'
                                                              : '-- %',
                                                          style: TextStyle(
                                                            color: totalReturn ==
                                                                    0
                                                                ? Colors.black
                                                                : totalReturn >
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
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
                                                            color: Color(
                                                                0xFFC4C4C4),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 11,
                                                        ),
                                                        Text(
                                                          NumberFormat("#,###")
                                                              .format(data
                                                                  .evaluationProfit),
                                                          style: TextStyle(
                                                            color: data.evaluationProfit ==
                                                                    0
                                                                ? Colors.black
                                                                : data.evaluationProfit >
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue,
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
                                        const Divider(
                                          color: Color(0xFFF4F4F4),
                                          height: 0,
                                          thickness: 1,
                                        )
                                      ],
                                    );
                                  },
                                )
                            : Container()
                        /* 20231211 거래내역 > 자산비중 으로 변경함으로 주석처리
                          Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 17,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xffDCDEE0),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _selectDate(context, 'st'),
                                                  child: Text(
                                                    stDateStr,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                child: const Text(
                                                  '~',
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _selectDate(context, 'ed'),
                                                  child: Text(
                                                    edDateStr,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            '상태',
                                            style: TextStyle(
                                              color: Color(0xffA8A8A8),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 44,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xffDCDEE0),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: DropdownButton(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              underline: Container(),
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_rounded),
                                              value: pGubn,
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
                                                _selectGubn(newValue);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const Text(
                                              '기업명',
                                              style: TextStyle(
                                                color: Color(0xffA8A8A8),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              height: 44,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(0xffDCDEE0),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  const Expanded(
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: getAssetRecord,
                                                    child: const FaIcon(
                                                      FontAwesomeIcons
                                                          .magnifyingGlass,
                                                      size: 15,
                                                      color: Color(0xff737A83),
                                                    ),
                                                  )
                                                ],
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
                           */
                        )
                  ];
                },
                body: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      curPage = value;
                    });
                  },
                  children: [
                    AssetmanageListPage(screenW: screenW),
                    const AssetmanageProportionPage(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
