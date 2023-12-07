import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_detail_vm.dart';

class PlanDetailMemoPage extends ConsumerStatefulWidget {
  final String corpCode;
  const PlanDetailMemoPage({super.key, required this.corpCode});

  @override
  ConsumerState<PlanDetailMemoPage> createState() => _PlanDetailMemoPageState();
}

class _PlanDetailMemoPageState extends ConsumerState<PlanDetailMemoPage> {
  final TextEditingController _textEditingController = TextEditingController();

  String memo = '';

  void onClear() {
    _textEditingController.clear();
    setState(() {
      memo = '';
    });
  }

  void addPlanMemo() async {
    await ref
        .read(planDetailMemoProvider(widget.corpCode).notifier)
        .addPlanMemo({'pCorpCode': widget.corpCode, 'pMemo': memo});
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '기록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(
                  color: Color(0xffEFEFEF),
                  thickness: 1,
                ),
                Expanded(
                  child:
                      ref.watch(planDetailMemoProvider(widget.corpCode)).when(
                            error: (error, stackTrace) => Center(
                              child: Text('error : $error'),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            data: (data) {
                              final memoList = data;
                              if (memoList != null) {
                                return ListView.builder(
                                  itemCount: memoList.length,
                                  itemBuilder: (context, index) {
                                    final memoData = memoList[index];
                                    return Container(
                                      child: Text(
                                          '${memoData.memo} ${memoData.createDt}'),
                                    );
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          height: 65,
          width: MediaQuery.of(context).size.width,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 5,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffC8C8C8),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        setState(() {
                          memo = value;
                          print('memo : $memo');
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: '메모를 남겨주세요',
                        hintStyle: const TextStyle(
                          color: Color(0xffcacaca),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: memo != ''
                            ? IconButton(
                                onPressed: onClear,
                                icon: const FaIcon(
                                  FontAwesomeIcons.xmark,
                                  color: Color(0xffbbbbbb),
                                ),
                              )
                            : null,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: addPlanMemo,
                    child: Container(
                      alignment: Alignment.center,
                      height: 65,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xffF5F5F5),
                      ),
                      child: const Text(
                        '등록',
                        style: TextStyle(
                          color: Color(0xffbbbbbb),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
