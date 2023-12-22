import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_detail_vm.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';
import 'package:jb_finance/utils.dart';

class TradeCorpDetailScreen extends ConsumerStatefulWidget {
  final String cropCode;
  final String corpName;
  final int avgPrice;
  final int holdQuantity;

  const TradeCorpDetailScreen({
    super.key,
    required this.cropCode,
    required this.corpName,
    required this.avgPrice,
    required this.holdQuantity,
  });

  @override
  ConsumerState<TradeCorpDetailScreen> createState() =>
      _TradeCorpDetailScreenState();
}

class _TradeCorpDetailScreenState extends ConsumerState<TradeCorpDetailScreen> {
  final TextEditingController _quantityEditController = TextEditingController();
  final TextEditingController _priceEditController = TextEditingController();

  DateTime now = DateTime.now();
  late DateTime curDate = now;

  late int curHoldQuantity = 0;
  late int curAvgPrice = 0;
  late int curDepositAmount = 0;

  //서버에서 사용할 파라미터
  late Map<String, dynamic> param = {
    'pCorpCode': widget.cropCode,
    'pTradeDate': DateFormat('yyyy-MM-dd').format(now),
    'pTradeGubn': '0101',
    'pTradePrice': '',
    'pQuantity': '',
  };

  @override
  void initState() {
    super.initState();
    getTradeCorpDetailInfo();
  }

  void onTapTradeGubn(String gubn) {
    setState(() {
      param['pTradeGubn'] = gubn;
    });
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: curDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        param['pTradeDate'] = DateFormat('yyyy-MM-dd').format(picked);
        curDate = picked;
      });
    }
  }

  void addTradeCorpDetail() async {
    focusOut(context);

    final gubn = param['pTradeGubn'];
    if (param['pQuantity'] == '' || param['pTradePrice'] == '') {
      return;
    } else if (param['pQuantity'] == '0' || param['pTradePrice'] == '0') {
      return;
    }

    final paramAmount =
        int.parse(param['pQuantity']) * int.parse(param['pTradePrice']);
    final paramQuantity = int.parse(param['pQuantity']);

    if (gubn == '0101') {
      if (paramAmount > curDepositAmount) {
        serverMessage(context, '매수금이 예수금을 초과하였습니다.');
        return;
      }
    } else {
      if (paramQuantity > curHoldQuantity) {
        serverMessage(context, '보유수량 초과매도를 할 수 없습니다.');
        return;
      }
    }

    _priceEditController.text = "";
    _quantityEditController.text = "";

    final detailInfo = await ref
        .read(tradeDetailProvider(widget.cropCode).notifier)
        .addTradeCorpDetail(param);

    setState(() {
      curAvgPrice = detailInfo['avgPrice'] ?? 0;
      curHoldQuantity = detailInfo['holdQuantity'] ?? 0;
      curDepositAmount = detailInfo['depositAmount'] ?? 0;
    });
  }

  void delTradeCorpDetail(int pSeq) async {
    Navigator.of(context).pop();

    final detailInfo = await ref
        .read(tradeDetailProvider(widget.cropCode).notifier)
        .delTradeCorpDetail(pSeq);

    setState(() {
      curAvgPrice = detailInfo['avgPrice'] ?? 0;
      curHoldQuantity = detailInfo['holdQuantity'] ?? 0;
      curDepositAmount = detailInfo['depositAmount'] ?? 0;
    });
  }

  Future<void> getTradeCorpDetailInfo() async {
    final detailInfo = await ref
        .read(tradeDetailProvider(widget.cropCode).notifier)
        .getTradeCorpDetailInfo(context);

    setState(() {
      curAvgPrice = detailInfo['avgPrice'] ?? 0;
      curHoldQuantity = detailInfo['holdQuantity'] ?? 0;
      curDepositAmount = detailInfo['depositAmount'] ?? 0;
    });
  }

  @override
  void dispose() {
    _priceEditController.dispose();
    _quantityEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusOut(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.corpName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          foregroundColor: const Color(0xFFA8A8A8),
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFFA8A8A8),
              width: 0.8,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 매수 매도 구분선택
              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  right: 20,
                  left: 20,
                  bottom: 15,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTapTradeGubn('0101'),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: param['pTradeGubn'] == '0101'
                                ? const Color(0xffF4364C)
                                : const Color(0xFFE7E7E7),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '매수',
                            style: TextStyle(
                              color: param['pTradeGubn'] == '0101'
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
                        onTap: () => onTapTradeGubn('0102'),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: param['pTradeGubn'] == '0102'
                                ? const Color(0xff477EEA)
                                : const Color(0xFFE7E7E7),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '매도',
                            style: TextStyle(
                              color: param['pTradeGubn'] == '0102'
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
              // 입력, 선택 박스
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              '날짜',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffA8A8A8),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffE5E7EA),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  DateFormat('yyyy년 MM월 dd일').format(curDate),
                                  style: const TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              '수량',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffA8A8A8),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE5E7EA),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: _quantityEditController,
                                style: const TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  param['pQuantity'] = value;
                                },
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text(
                              '가격',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffA8A8A8),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE5E7EA),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: _priceEditController,
                                style: const TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  param['pTradePrice'] = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* 
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              '가격',
                              style: TextStyle(
                                color: Color(0xffA8A8A8),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffE5E7EA),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (value) {
                                  param['pTradePrice'] = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                   */
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // 저장버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: addTradeCorpDetail,
                    style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(
                          Color(0xff333333),
                        ),
                        overlayColor: MaterialStatePropertyAll(
                          Colors.white.withOpacity(0.25),
                        )),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // 현재 보유수량 / 평단
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffEFEFEF),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xffFCFCFC),
                                  border: Border(
                                    right: BorderSide(
                                        color: Color(0xffefefef), width: 1.5),
                                  ),
                                ),
                                child: const Text('예수금'),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                NumberFormat('#,###').format(curDepositAmount),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        color: Color(0xffEFEFEF),
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xffFCFCFC),
                                  border: Border(
                                    right: BorderSide(
                                        color: Color(0xffefefef), width: 1.5),
                                  ),
                                ),
                                child: const Text('보유수량'),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                NumberFormat('#,###').format(curHoldQuantity),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color(0xffFCFCFC),
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xffefefef),
                                      width: 1.5,
                                    ),
                                    right: BorderSide(
                                        color: Color(0xffefefef), width: 1.5),
                                  ),
                                ),
                                child: const Text('평균단가'),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                NumberFormat('#,###').format(curAvgPrice),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 거래이력 리스트
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '거래내역',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Divider(
                      color: Color(0xff333333),
                      thickness: 2,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: ref.watch(tradeDetailProvider(widget.cropCode)).when(
                      error: (error, stackTrace) => Center(
                        child: Text('error: $error'),
                      ),
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      data: (data) {
                        final recordList = data;
                        if (recordList == null) {
                          return const Center(
                            child: Text('거래기록이 없습니다.'),
                          );
                        } else {
                          return Column(
                            children: [
                              for (int i = 0; i < recordList.length; i++)
                                GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        elevation: 0,
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('삭제하시겠습니까?'),
                                          ],
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                      Colors.red.shade300,
                                                    ),
                                                    overlayColor:
                                                        MaterialStatePropertyAll(
                                                      Colors.white
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      delTradeCorpDetail(
                                                          recordList[i].seq),
                                                  child: const Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        const MaterialStatePropertyAll(
                                                      Colors.grey,
                                                    ),
                                                    overlayColor:
                                                        MaterialStatePropertyAll(
                                                      Colors.white
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Text(
                                                    '취소',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 20,
                                      right: 27,
                                      left: 27,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xffEFEFEF),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateFormat('yyyy. MM. dd').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      recordList[i].tradeDate)),
                                          style: const TextStyle(
                                            color: Color(0xffC4C4C4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundColor:
                                                  recordList[i].gubn == '0101'
                                                      ? const Color(0xffFFDADE)
                                                      : const Color.fromARGB(
                                                          255, 213, 227, 255),
                                              child: Text(
                                                recordList[i].gubn == '0101'
                                                    ? '매수'
                                                    : '매도',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: recordList[i].gubn ==
                                                            '0101'
                                                        ? Colors.red
                                                        : Colors.blue),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    recordList[i].corpName,
                                                    style: const TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    recordList[i].gubn == '0101'
                                                        ? '${NumberFormat('#,###').format(recordList[i].tradePrice)}원  ·  ${recordList[i].buyQuantity}주'
                                                        : '${NumberFormat('#,###').format(recordList[i].tradePrice)}원  ·  ${recordList[i].sellQuantity}주',
                                                    style: const TextStyle(
                                                      color: Color(0xffC4C4C4),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                textAlign: TextAlign.right,
                                                recordList[i].gubn == '0101'
                                                    ? '${NumberFormat('#,###').format(recordList[i].buyAmount)} 원'
                                                    : '${NumberFormat('#,###').format(recordList[i].sellAmount)} 원',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                          /* 
                            return ListView.builder(
                              itemCount: recordList.length,
                              itemBuilder: (context, index) {
                                final recordData = recordList[index];
              
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 20,
                                        right: 27,
                                        left: 27,
                                      ),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xffEFEFEF),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat('yyyy. MM. dd').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        recordData.tradeDate)),
                                            style: const TextStyle(
                                              color: Color(0xffC4C4C4),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundColor: recordData
                                                            .gubn ==
                                                        '0101'
                                                    ? const Color(0xffFFDADE)
                                                    : const Color.fromARGB(
                                                        255, 213, 227, 255),
                                                child: Text(
                                                  recordData.gubn == '0101'
                                                      ? '매수'
                                                      : '매도',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                      color: recordData.gubn ==
                                                              '0101'
                                                          ? Colors.red
                                                          : Colors.blue),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      recordData.corpName,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff333333),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      recordData.gubn == '0101'
                                                          ? '${NumberFormat('#,###').format(recordData.tradePrice)}원  ·  ${recordData.buyQuantity}주'
                                                          : '${NumberFormat('#,###').format(recordData.tradePrice)}원  ·  ${recordData.sellQuantity}주',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xffC4C4C4),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  textAlign: TextAlign.right,
                                                  recordData.gubn == '0101'
                                                      ? '${NumberFormat('#,###').format(recordData.buyAmount)} 원'
                                                      : '${NumberFormat('#,###').format(recordData.sellAmount)} 원',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                         */
                        }
                      },
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
