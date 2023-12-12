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

  @override
  Widget build(BuildContext context) {
    print('${widget.index} 화면 리빌드');
    final provider = widget.index == 0
        ? ref.watch(planAllProvider)
        : widget.index == 1
            ? ref.watch(planShortProvider)
            : widget.index == 2
                ? ref.watch(planMediumProvider)
                : ref.watch(planLongProvider);

    return provider.when(
      error: (error, stackTrace) => Center(
        child: Text('error : $error'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        final planbookList = data;
        if (planbookList != null) {
          return ListView.separated(
            itemCount: planbookList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final planbook = planbookList[index];
              return GestureDetector(
                onTap: () => _goPlanDetailScreen(
                    planbook.corpCode,
                    planbook.corpName,
                    planbook.befClsPrice,
                    planbook.periodGubn),
                child: Container(
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
                              color: const Color(0xffFFE0DE),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text(
                              '매수',
                              style: TextStyle(
                                color: Color(0xffe84a41),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            '7만원대 올라서면 매수하기 👍',
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
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
