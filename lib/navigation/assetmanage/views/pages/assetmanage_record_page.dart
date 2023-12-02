import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';

class AssetmanageRecordPage extends ConsumerStatefulWidget {
  const AssetmanageRecordPage({
    super.key,
  });

  @override
  ConsumerState<AssetmanageRecordPage> createState() =>
      _AssetmanageRecordPageState();
}

class _AssetmanageRecordPageState extends ConsumerState<AssetmanageRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Divider(
            color: Color(0xffEFEFEF),
            thickness: 1,
          ),
          Expanded(
            child: ref.watch(assetRecordProvider).when(
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
