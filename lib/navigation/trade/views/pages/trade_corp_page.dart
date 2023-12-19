import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';
import 'package:jb_finance/navigation/trade/views/trade_corp_detail_screen.dart';

class TradeCorpPage extends ConsumerStatefulWidget {
  const TradeCorpPage({super.key});

  @override
  ConsumerState<TradeCorpPage> createState() => _TradeCorpPageState();
}

class _TradeCorpPageState extends ConsumerState<TradeCorpPage> {
  void goTradeCorpDetail(
      String corpCode, String corpName, int avgPrice, int holdQuantity) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TradeCorpDetailScreen(
        cropCode: corpCode,
        corpName: corpName,
        avgPrice: avgPrice,
        holdQuantity: holdQuantity,
      ),
    ));
  }

  void getTradeCorpList() async {
    await ref.read(tradeCorpListProvider.notifier).getTradeCorpList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ref.watch(tradeCorpListProvider).when(
              error: (error, stackTrace) => Center(
                    child: Text('error : $error'),
                  ),
              loading: () {
                getTradeCorpList();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              data: (data) {
                final corpList = data;
                if (corpList == null) {
                  return const Center(
                    child: Text('등록된 기업이 없습니다.'),
                  );
                } else {
                  return ListView.separated(
                    itemCount: corpList.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      final corpData = corpList[index];
                      return GestureDetector(
                        onTap: () => goTradeCorpDetail(
                            corpData.corpCode,
                            corpData.corpName,
                            corpData.avgPrice,
                            corpData.holdQuantity),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffE5E7EA),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            corpData.corpName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${NumberFormat('#,###').format(corpData.befClsPrice)} 원',
                                              style: const TextStyle(
                                                color: Color(0xffEC4452),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                corpData.changeDt)),
                                        style: const TextStyle(
                                          color: Color(0xffc4c4c4),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '보유',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xffc4c4c4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '평균단가',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xffc4c4c4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '실현손익',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xffc4c4c4),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${corpData.holdQuantity} 주',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          NumberFormat('#,###')
                                              .format(corpData.avgPrice),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          NumberFormat('#,###')
                                              .format(corpData.returnAmount),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: corpData.returnAmount == 0
                                                ? null
                                                : corpData.returnAmount > 0
                                                    ? Colors.red.shade300
                                                    : Colors.blue.shade300,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}
