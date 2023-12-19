import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_vm.dart';
import 'package:jb_finance/navigation/planbook/views/planbook_detail_screen.dart';

class PlanbookListPage extends ConsumerStatefulWidget {
  final int index;
  const PlanbookListPage({super.key, required this.index});

  @override
  ConsumerState<PlanbookListPage> createState() => _PlanbookListPageState();
}

class _PlanbookListPageState extends ConsumerState<PlanbookListPage> {
  List<Color> periodColor = [
    Colors.grey,
    Colors.blue,
    Colors.amber,
    Colors.orange
  ];

  void _goPlanDetailScreen(
      String corpCode, String corpName, int befClsPrice, String? periodGubn) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlanbookDetailScreen(
          corpCode: corpCode,
          corpName: corpName,
          befClsPrice: befClsPrice,
          periodGubn: periodGubn,
        ),
      ),
    );
  }

  void getPlanbookList() async {
    await ref.read(planProvider.notifier).getPlanbookList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(planProvider);

    return provider.when(
      error: (error, stackTrace) => Center(
        child: Text('error : $error'),
      ),
      loading: () {
        print('planbook 로딩 ~~~~~~~~~~~~~');
        getPlanbookList();
        return const Center(child: CircularProgressIndicator());
      },
      data: (data) {
        final planbookList = data;
        if (planbookList != null) {
          return ListView.separated(
            itemCount: planbookList.length,
            separatorBuilder: (context, index) {
              final planbook = planbookList[index];
              final page = widget.index;
              if ((page == 0 && planbook.periodGubn == null) ||
                  (page == 1 && planbook.periodGubn == '0601') ||
                  (page == 2 && planbook.periodGubn == '0602') ||
                  (page == 3 && planbook.periodGubn == '0603')) {
                return const SizedBox(height: 12);
              } else {
                return Container();
              }
            },
            itemBuilder: (context, index) {
              print('$index / ${planbookList.length}');
              final planbook = planbookList[index];
              final page = widget.index;
              print('${widget.index} 화면 ${planbook.periodGubn}');
              if ((page == 0 && planbook.periodGubn == null) ||
                  (page == 1 && planbook.periodGubn == '0601') ||
                  (page == 2 && planbook.periodGubn == '0602') ||
                  (page == 3 && planbook.periodGubn == '0603')) {
                return GestureDetector(
                  onTap: () => _goPlanDetailScreen(
                      planbook.corpCode,
                      planbook.corpName,
                      planbook.befClsPrice,
                      planbook.periodGubn),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffE4E4E4),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: periodColor[widget.index],
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                planbook.periodNm,
                                style: const TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              planbook.corpName,
                              style: const TextStyle(
                                color: Color(0xffa8a8a8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                '${NumberFormat('#,###').format(planbook.befClsPrice)}원',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      planbook.changeDt)
                                  .toString()
                                  .split(' ')
                                  .first,
                              style: const TextStyle(
                                color: Color(0xffa8a8a8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                color: planbook.investOpinion == '미추정'
                                    ? Colors.grey.shade200
                                    : planbook.investOpinion == '매수'
                                        ? Colors.red.shade100
                                        : planbook.investOpinion == '비중확대'
                                            ? Colors.red.shade100
                                            : planbook.investOpinion == '중립'
                                                ? Colors.grey.shade200
                                                : planbook.investOpinion ==
                                                        '비중축소'
                                                    ? Colors.blue.shade100
                                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                '${planbook.investOpinion}',
                                style: TextStyle(
                                  color: planbook.investOpinion == '미추정'
                                      ? Colors.grey
                                      : planbook.investOpinion == '매수'
                                          ? Colors.red
                                          : planbook.investOpinion == '비중확대'
                                              ? Colors.red
                                              : planbook.investOpinion == '중립'
                                                  ? Colors.grey
                                                  : planbook.investOpinion ==
                                                          '비중축소'
                                                      ? Colors.blue
                                                      : Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                planbook.memo ?? '작성된 메모가 없습니다.',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: planbook.memo == null
                                      ? Colors.grey
                                      : const Color(0xff333333),
                                  fontSize: planbook.memo == null ? 14 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return const Center(
            child: Text('목표관리 대상 기업이 없습니다.'),
          );
        }
      },
    );
  }
}
