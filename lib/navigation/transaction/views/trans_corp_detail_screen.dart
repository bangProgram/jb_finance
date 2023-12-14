import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/utils.dart';

class TransCorpDetailScreen extends StatefulWidget {
  final String corpName;
  const TransCorpDetailScreen({super.key, required this.corpName});

  @override
  State<TransCorpDetailScreen> createState() => _TransCorpDetailScreenState();
}

class _TransCorpDetailScreenState extends State<TransCorpDetailScreen> {
  DateTime now = DateTime.now();
  late DateTime curDate = now;

  //서버에서 사용할 파라미터
  late Map<String, dynamic> param = {
    'pTradeDate': DateFormat('yyyy-MM-dd').format(now),
    'pGubn': '0101',
    'pHoldQuantity': '',
    'pTradePrice': '',
  };

  void onTapTransGubn(String gubn) {
    setState(() {
      param['pGubn'] = gubn;
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

  void addTransCorpDetail() async {
    focusOut(context);
    if (param['pHoldQuantity'] == '' || param['pTradePrice'] == '') return;
    print('test : $param');
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
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          elevation: 1,
          foregroundColor: const Color(0xFFA8A8A8),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // 매수 매도 구분선택
            Container(
              padding: const EdgeInsets.only(
                top: 25,
                right: 20,
                left: 20,
                bottom: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapTransGubn('0101'),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: param['pGubn'] == '0101'
                              ? const Color(0xffF4364C)
                              : const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '매수',
                          style: TextStyle(
                            color: param['pGubn'] == '0101'
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
                      onTap: () => onTapTransGubn('0102'),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          color: param['pGubn'] == '0102'
                              ? const Color(0xff477EEA)
                              : const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '매도',
                          style: TextStyle(
                            color: param['pGubn'] == '0102'
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
                          flex: 1,
                          child: Text(
                            '수량',
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
                                param['pHoldQuantity'] = value;
                              },
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
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // 저장버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: addTransCorpDetail,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff333333),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '저장',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
