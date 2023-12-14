import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/transaction/view_models/transaction_vm.dart';

class TransRecordPage extends ConsumerStatefulWidget {
  const TransRecordPage({
    super.key,
  });

  @override
  ConsumerState<TransRecordPage> createState() => _TransRecordPageState();
}

class _TransRecordPageState extends ConsumerState<TransRecordPage> {
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
        getTransRecord();
      });
    }
  }

  void _selectGubn(String? gubn) {
    setState(() {
      pGubn = gubn;
      searchParam['pGubn'] = gubn;
      getTransRecord();
    });
  }

  void getTransRecord() async {
    print('param : $searchParam');
    await ref.read(transRecordProvider.notifier).getTransRecord(searchParam);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, 'st'),
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
                                onTap: () => _selectDate(context, 'ed'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            borderRadius: BorderRadius.circular(15),
                            underline: Container(),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    onChanged: (value) {
                                      searchParam['pCorpName'] = value;
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: getTransRecord,
                                  child: const FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
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
          Expanded(
            child: ref.watch(transRecordProvider).when(
                  error: (error, stackTrace) => Center(
                    child: Text('error: $error'),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  data: (data) {
                    final recordList = data;
                    if (recordList == null) {
                      return const Center(
                        child: Text('거래기록이 없습니다.'),
                      );
                    } else {
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat('yyyy. MM. dd').format(
                                          DateTime.fromMillisecondsSinceEpoch(
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
                                          backgroundColor:
                                              recordData.gubn == '0101'
                                                  ? const Color(0xffFFDADE)
                                                  : const Color.fromARGB(
                                                      255, 213, 227, 255),
                                          child: Text(
                                            recordData.gubn == '0101'
                                                ? '매수'
                                                : '매도',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: recordData.gubn == '0101'
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
                                                  color: Color(0xff333333),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                recordData.gubn == '0101'
                                                    ? '${NumberFormat('#,###').format(recordData.tradePrice)}원  ·  ${recordData.buyQuantity}주'
                                                    : '${NumberFormat('#,###').format(recordData.tradePrice)}원  ·  ${recordData.sellQuantity}주',
                                                style: const TextStyle(
                                                  color: Color(0xffC4C4C4),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
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
                                        /* 
                                        Expanded(
                                          child: Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      recordData.corpCode,
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
                                                          ? '${recordData.tradePrice} · ${recordData.buyQuantity}주'
                                                          : '${recordData.tradePrice} · ${recordData.sellQuantity}주',
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
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  textAlign: TextAlign.right,
                                                  recordData.gubn == '0101'
                                                      ? '${recordData.buyAmount} 원'
                                                      : '${recordData.sellAmount} 원',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                       */
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
          ),
        ],
      ),
    );
  }
}
